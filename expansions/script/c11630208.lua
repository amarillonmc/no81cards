--造型镜·碎片拼接
local m=11630208
local cm=_G["c"..m]
function c11630208.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)	 
end
cm.SetCard_xxj_Mirror=true
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RACE)
	local ra=Duel.AnnounceRace(tp,1,RACE_ALL)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
	local att=Duel.AnnounceAttribute(tp,1,0x7f)
	Duel.Hint(HINT_SELECTMSG,tp,HINGMSG_LVRANK)
	local lv=Duel.AnnounceLevel(tp,1,12)
	e:SetLabel(ra,att,lv)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.costfil(c) 
	return c:IsType(TYPE_MONSTER)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local c=e:GetHandler()
	local ra,att,lv=e:GetLabel()
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,11630209,0,TYPES_TOKEN_MONSTER,0,0,lv,ra,att) then return end
	local g=Group.CreateGroup()
	local token=Duel.CreateToken(tp,11630209)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetValue(lv)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	token:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_RACE)
	e2:SetValue(ra)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	token:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e3:SetValue(att)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	token:RegisterEffect(e3)
	Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	Duel.BreakEffect()
	if Duel.SpecialSummonComplete() and Duel.CheckReleaseGroupEx(tp,cm.costfil,1,token) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		local rg=Duel.SelectReleaseGroupEx(tp,cm.costfil,1,1,token)
		Duel.Release(rg,REASON_EFFECT)
		local tc=rg:GetFirst()
		local op=Duel.SelectOption(tp,aux.Stringid(m,2),aux.Stringid(m,3))
		if op==0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_ADD_TYPE)
			e1:SetValue(TYPE_TUNER)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			token:RegisterEffect(e1)
		else
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_CHANGE_CODE)
			e1:SetValue(tc:GetCode())
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			token:RegisterEffect(e1)
		end
	end
end