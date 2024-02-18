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
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { BarCart } from "../charts/BarChart";
import TempChart from "../charts/TempChart";

export function AccordionDemo() {
  const [allRecords, setAllRecords] = useState<any[]>([]);
  const [petData, setPetData] = useState<any>({});
  const searchParams = useSearchParams();
  const { user } = useAuthState();

  const search = searchParams.get("id");
  const fetchAllData = async () => {
    if (user && search) {
      const data = await fetchAllHistoryData(search);
      setAllRecords(data?.allRecords || []);
      setPetData(data?.allData);
    }
  };
  useEffect(() => {
    fetchAllData();
  }, [user, search]);
  return (
    <>
      <div> Dog Name - {petData?.name} </div>
      <div>
        <Card>
          <CardHeader>AI Suggestions </CardHeader>
          <CardContent>{petData?.["doctor-suggestion"] ?? "None"}</CardContent>
        </Card>
      </div>
      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-7">
        <Card className="col-span-3">
          <CardHeader>
            <CardTitle>Weight Overview</CardTitle>
          </CardHeader>
          <CardContent className="pl-2">
            <BarCart />
          </CardContent>
        </Card>
        <Card className="col-span-3">
          <CardHeader>
            <CardTitle>Activity Overview</CardTitle>
          </CardHeader>
          <CardContent className="pl-2">
            <TempChart />
          </CardContent>
        </Card>
      </div>
      <div>
        <Accordion type="single" collapsible className="w-full">
          {allRecords.map((record, idx) => (
            <AccordionItem key={idx} value={idx.toString()}>
              <AccordionTrigger>
                {record?.dateTime.toDate().toLocaleDateString()} -
                {record?.dateTime.toDate().toLocaleTimeString()}
              </AccordionTrigger>
              <AccordionContent>
                <div>Food : {record?.food ?? "-"} </div>
                <div>Weight : {record?.weight ?? "-"} lbs </div>
                <div>Medications: {record?.medications ?? "-"} </div>
                <div>Symptoms: {record?.symptoms ?? "-"} </div>
                <div>Activity Score: {record?.activityScore ?? "-"} </div>
              </AccordionContent>
            </AccordionItem>
          ))}
        </Accordion>
      </div>
    </>
  );
}
