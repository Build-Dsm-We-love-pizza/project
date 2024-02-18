import {
  collection,
  getDocs,
  query,
  where,
  doc,
  getDoc,
} from "firebase/firestore";
import { db } from "./config";
import { Appointment } from "@/components/Table/TableComponentForAppointemnts";

export const getUserEmail = async () => {};

export const fetchAllAppointments = async (vetId: string) => {
  try {
    const appointmentRef = collection(db, "appointments");
    const q = query(appointmentRef, where("vet_id", "==", vetId));
    const querySnapshot = await getDocs(q);
    const allData: Appointment[] = [];
    querySnapshot.forEach((doc) => {
      const d = doc.data();
      allData.push({
        onTime: d?.onTime,
        pet_id: d?.pet_id,
        user_id: d?.user_id,
        vet_id: d?.vet_id,
      });
    });
    return allData;
  } catch (err) {
    console.log(err);
  }
};

export const fetchAllHistoryData = async (petId: string) => {
  try {
    const petsRef = doc(db, "pets", petId);
    const recordRef = collection(petsRef, "records");
    const querySnapshot = await getDoc(petsRef);
    const recordsSnap = await getDocs(recordRef);
    let allData: any = querySnapshot.data();
    const allRecords: any[] = [];

    recordsSnap.forEach((doc) => {
      allRecords.push({ ...doc.data() });
    });
    console.log(allData);
    console.log(allRecords);
    return { allData, allRecords };
  } catch (err) {
    console.log(err);
  }
};
