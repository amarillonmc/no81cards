--神龙 默示神判龙
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(10174053)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1,e2,e3=rsef.FV_CHANGE(c,"lv,att,race",{ 10,ATTRIBUTE_DARK,RACE_FIEND },cm.tg,{ LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE })
	local e4=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,0},nil,"rm,atk","de,dsp",rscon.sumtype("rit"),cm.rmcost,rsop.target(cm.rmfilter,"rm",LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,true),cm.rmop)
end
function cm.tg(e,c)
	return c~=e:GetHandler()
end
function cm.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetAttackAnnouncedCount()==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function cm.rmfilter(c)
	return c:IsRace(RACE_FIEND) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToRemove()
end 
function cm.rmop(e,tp)
	local c=rscf.GetFaceUpSelf(e)
	local g=Duel.GetMatchingGroup(cm.rmfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,nil)
	if #g>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 and c then
		local og=Duel.GetOperatedGroup()
		local atk=og:GetSum(Card.GetBaseAttack)
		local e1=rsef.SV_UPDATE(c,"atk",atk,nil,rsreset.est_d)
	end
end
