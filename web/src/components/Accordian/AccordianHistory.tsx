"use client";
import {
  Accordion,
  AccordionContent,
  AccordionItem,
  AccordionTrigger,
} from "@/components/ui/accordion";
import { useSearchParams } from "next/navigation";
import { useEffect, useState } from "react";
import useAuthState from "../hooks/useAuthState";
import { fetchAllHistoryData } from "@/firebase/fetchers";

export function AccordionDemo() {
  const [allRecords, setAllRecords] = useState<any[]>([]);
  const searchParams = useSearchParams();
  const { user } = useAuthState();

  const search = searchParams.get("id");
  const fetchAllData = async () => {
    if (user && search) {
      const data = await fetchAllHistoryData(search);
      setAllRecords(data?.allRecords || []);
    }
  };
  useEffect(() => {
    fetchAllData();
  }, [user, search]);
  return (
    <Accordion type="single" collapsible className="w-full">
      {allRecords.map((record, idx) => (
        <AccordionItem key={idx} value={idx.toString()}>
          <AccordionTrigger>
            {record?.dateTime.toDate().toLocaleDateString()} -
            {record?.dateTime.toDate().toLocaleTimeString()}
          </AccordionTrigger>
          <AccordionContent>
            <div>Food : {record?.food} </div>
            <div>Weight : {record?.weight} lbs </div>
          </AccordionContent>
        </AccordionItem>
      ))}
    </Accordion>
  );
}
