"use client";
import React, { use, useEffect } from "react";
import useAuthState from "./hooks/useAuthState";
import { useRouter } from "next/navigation";
import { usePathname } from "next/navigation";

export default function AuthCheck() {
  const { isLoading, user } = useAuthState();
  const router = useRouter();
  const pathname = usePathname();

  useEffect(() => {
    if (isLoading === null) return;
    if (!user && !isLoading && router) {
      router.push("/signin");
    }
    //console.log(pathname);
    if (user && !isLoading && pathname === "/signin") {
      router.push("/");
    }
  }, [isLoading, router, user]);
  return null;
}
