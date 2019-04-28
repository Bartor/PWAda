package body RandGen is
   subtype Rand_Range is Positive;
   package Rand_Int is new Ada.Numerics.Discrete_Random(Rand_Range);

   gen: Rand_Int.generator;

   function get_random(n: in Positive) return Integer is
   begin

      return Rand_Int.Random(gen) mod n;

   end get_random;

begin
    Rand_Int.Reset(gen);
end RandGen;
