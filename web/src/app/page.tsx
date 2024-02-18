import AuthCheck from "@/components/AuthCheck";
import { TableComponentForAppointemnts } from "@/components/Table/TableComponentForAppointemnts";
import { MainNav } from "@/components/header/main-nav";
import { UserNav } from "@/components/header/user-nav";

export default function Home() {
  return (
    <main>
      <AuthCheck />
      <div className="hidden flex-col md:flex">
        <div className="border-b">
          <div className="flex h-16 items-center px-4">
            <MainNav className="mx-6" />
            <div className="ml-auto flex items-center space-x-4">
              <UserNav />
            </div>
          </div>
        </div>
      </div>
      <div className="hidden h-full flex-1 flex-col space-y-8 p-8 md:flex">
        <TableComponentForAppointemnts />
      </div>
    </main>
  );
}
