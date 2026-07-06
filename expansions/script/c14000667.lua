--混调色-淡色
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
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(s.atkval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,id)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCondition(s.descon)
	e5:SetTarget(s.destg)
	e5:SetOperation(s.desop)
	c:RegisterEffect(e5)
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
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsType(TYPE_SPELL+TYPE_TRAP) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,TYPE_SPELL+TYPE_TRAP) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,TYPE_SPELL+TYPE_TRAP)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then Duel.Destroy(tc,REASON_EFFECT) end
end