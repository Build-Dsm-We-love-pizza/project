"use client";
import {
  Table,
  TableBody,
  TableCaption,
  TableCell,
  TableFooter,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { fetchAllAppointments } from "@/firebase/fetchers";
import firebase from "firebase/compat/app";
import { useEffect, useState } from "react";
import useAuthState from "../hooks/useAuthState";
import { useRouter } from "next/navigation";

export interface Appointment {
  vet_id: string;
  pet_id: string;
  onTime: firebase.firestore.Timestamp;
  user_id: string;
}

export function TableComponentForAppointemnts() {
  const [allAppointments, setAllAppointments] = useState<Appointment[]>([]);
  const { user } = useAuthState();
  const router = useRouter();

  const fetchApp = async (uid: string) => {
    const res = await fetchAllAppointments(uid);
    if (res !== undefined) {
      setAllAppointments(res);
    }
  };

  useEffect(() => {
    if (user?.uid) fetchApp(user?.uid);
  }, [user]);

  const onClick = (p_id: string) => {
    router.push(`/showHistory?id=${p_id}`);
  };
  return (
    <Table>
      <TableCaption>All Appointments</TableCaption>
      <TableHeader>
        <TableRow>
          <TableHead>Name</TableHead>
          <TableHead>Date</TableHead>
          <TableHead>Time</TableHead>
          <TableHead className="text-right">Pet-id</TableHead>
        </TableRow>
      </TableHeader>
      <TableBody>
        {allAppointments.map((appointment) => (
          <TableRow
            onClick={() => onClick(appointment.pet_id)}
            key={appointment.user_id}
          >
            <TableCell>{appointment.user_id}</TableCell>
            <TableCell className="font-medium">
              {appointment.onTime.toDate().toLocaleDateString()}
            </TableCell>
            <TableCell>
              {appointment.onTime.toDate().toLocaleTimeString()}
            </TableCell>
            <TableCell className="text-right">{appointment.pet_id}</TableCell>
          </TableRow>
        ))}
      </TableBody>
      <TableFooter>
        <TableRow></TableRow>
      </TableFooter>
    </Table>
  );
}
