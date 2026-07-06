--混调色交织
local s,id,o=GetID()
s.named_with_Combine_Color=1
function s.cc(c)
	if not c then return false end
	if _G["Combine_Color_Global_Codes"] and (_G["Combine_Color_Global_Codes"][c:GetCode()] or _G["Combine_Color_Global_Codes"][c:GetOriginalCode()]) then return true end
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Combine_Color
end
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.filter0(c)
	return c:IsAbleToHand()
end
function s.filter1(c,mg,tp)
	if not s.cc(c) or not c:IsType(TYPE_FUSION) then return false end
	return c:CheckFusionMaterial(mg,nil,tp)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(s.filter0,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
		return Duel.IsExistingMatchingCard(s.filter1,tp,0xff,0xff,1,nil,mg,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.filter0),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g_fc=Duel.SelectMatchingCard(tp,s.filter1,tp,0xff,0xff,1,1,nil,mg,tp)
	local fc=g_fc:GetFirst()
	if not fc then return end
	if fc:IsFacedown() or fc:IsLocation(LOCATION_EXTRA) or fc:IsLocation(LOCATION_DECK) or fc:IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,fc)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local mats=Duel.SelectFusionMaterial(tp,fc,mg,nil,tp)
	if mats:GetCount()==0 then return end
	local thg=Group.CreateGroup()
	if mats:GetCount()>3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		thg=mats:Select(tp,1,3,nil)
	else
		thg=mats
	end
	if thg:GetCount()>0 then
		Duel.SendtoHand(thg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,thg)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(s.splimit)
	Duel.RegisterEffect(e1,tp)
end
function s.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsSetCard(0x46)
end