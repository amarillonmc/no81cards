--征王龙
local m=91000010
local cm=c91000010
function c91000010.initial_effect(c)
		aux.AddXyzProcedure(c,c91000010.mfilter,7,2,c91000010.ovfilter,aux.Stringid(10443957,0),3,c91000010.xyzop)
	c:EnableReviveLimit()
end
function c91000010.mfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c91000010.ovfilter(c)
	return c:IsFaceup() and (c:IsCode(26400609) or c:IsCode(53804307) or c:IsCode(89399912) or c:IsCode(90411554))
end
function c91000010.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,91000010)==0 end
	Duel.RegisterFlagEffect(tp,91000010,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end