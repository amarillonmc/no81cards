--混调色-暖色
local s,id,o=GetID()
s.named_with_Combine_Color=1
function s.cc(c)
	if not c then return false end
	if _G["Combine_Color_Global_Codes"] and (_G["Combine_Color_Global_Codes"][c:GetCode()] or _G["Combine_Color_Global_Codes"][c:GetOriginalCode()]) then return true end
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Combine_Color
end
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,s.cc,aux.NonTuner(nil),1,c:GetLevel()-1)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(s.stsyncon)
	e1:SetTarget(s.stsyntg)
	e1:SetOperation(s.stsynop)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(s.atkval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,id)
	e4:SetCondition(s.tgcon)
	e4:SetTarget(s.tgtg)
	e4:SetOperation(s.tgop)
	c:RegisterEffect(e4)
end
function s.stsyncon(e,c)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	local lv=c:GetLevel()
	local remain=lv-3
	if remain<=0 then return false end
	if not Duel.IsExistingMatchingCard(s.stfilter,tp,LOCATION_ONFIELD,0,1,nil) then
		return false
	end
	local nt_g=Duel.GetMatchingGroup(aux.NonTuner(nil),tp,LOCATION_MZONE,0,nil,c)
	return nt_g:CheckWithSumEqual(Card.GetSynchroLevel,remain,1,remain,c)
end
function s.stsyntg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local lv=c:GetLevel()
	local remain=lv-3
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local stg=Duel.SelectMatchingCard(tp,s.stfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	if stg:GetCount()==0 then return end
	local stc=stg:GetFirst()
	local nt_mg=Duel.GetMatchingGroup(aux.NonTuner(nil),tp,LOCATION_MZONE,0,nil,c)
	local function nt_goal(g,syncard,target_lv)
		return g:GetSum(Card.GetSynchroLevel,syncard)==target_lv
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local cancel=Duel.IsSummonCancelable()
	local nt_g=nt_mg:SelectSubGroup(tp,nt_goal,cancel,1,remain,c,remain)
	if not nt_g or nt_g:GetCount()==0 then return end
	local mat_g=Group.CreateGroup()
	mat_g:AddCard(stc)
	mat_g:Merge(nt_g)
	if mat_g then
		mat_g:KeepAlive()
		e:SetLabelObject(mat_g)
		return true
	else
		return false
	end
end
function s.stsynop(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	local tg=e:GetLabelObject()
	if not tg then return end
	local fdg=tg:Filter(Card.IsFacedown,nil)
	if fdg then
		Duel.ConfirmCards(1-tp,fdg)
	end
	c:SetMaterial(tg)
	Duel.SendtoGrave(tg,REASON_MATERIAL+REASON_SYNCHRO)
	tg:DeleteGroup()
end
function s.stfilter(c)
	return s.cc(c) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP))
end
function s.atkval(e,c)
	local g=c:GetMaterial()
	if g:GetCount()==0 then return 0 end
	local mt={}
	for tc in aux.Next(g) do
		if tc:IsType(TYPE_MONSTER) then mt[TYPE_MONSTER]=true end
		if tc:IsType(TYPE_SPELL) then mt[TYPE_SPELL]=true end
		if tc:IsType(TYPE_TRAP) then mt[TYPE_TRAP]=true end
	end
	local ct=0
	if mt[TYPE_MONSTER] then ct=ct+1 end
	if mt[TYPE_SPELL] then ct=ct+1 end
	if mt[TYPE_TRAP] then ct=ct+1 end
	return g:GetCount()*ct*100
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function s.tgfilter(c)
	return s.cc(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
			if g:GetCount()>0 then 
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) 
			end
		end
	end
end
function s.spfilter(c,e,tp)
	return s.cc(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end