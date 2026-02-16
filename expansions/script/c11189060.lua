--湮潮使·月
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c)
	--
	c:EnableCounterPermit(0x452)
	aux.AddCodeList(c,0x452)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--special summon rule
	local e0_1=Effect.CreateEffect(c)
	e0_1:SetType(EFFECT_TYPE_FIELD)
	e0_1:SetCode(EFFECT_SPSUMMON_PROC)
	e0_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0_1:SetRange(LOCATION_EXTRA)
	e0_1:SetCondition(s.sprcon)
	e0_1:SetTarget(s.sprtg)
	e0_1:SetOperation(s.sprop)
	c:RegisterEffect(e0_1)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.ptg1)
	e1:SetOperation(s.pop1)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.mtg1)
	e2:SetOperation(s.mop1)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,id+1)
	e3:SetCost(s.mcost2)
	e3:SetTarget(s.mtg2)
	e3:SetOperation(s.mop2)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,3))
	e4:SetCategory(CATEGORY_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,id+2)
	e4:SetTarget(s.mtg3)
	e4:SetOperation(s.mop3)
	c:RegisterEffect(e4)
end
function s.sprfilter(c)
	return c:IsFaceup() and aux.IsCodeListed(c,0x452) 
end
function s.fselect1(g,tp,sc)
	return Duel.GetLocationCountFromEx(tp,tp,g,sc)>0 and g:IsExists(Card.IsAbleToGraveAsCost,2,nil)
end
function s.fselect2(g,tp,sc)
	return Duel.GetLocationCountFromEx(tp,tp,g,sc)>0 and g:IsExists(Card.IsAbleToRemoveAsCost,2,nil)
end
function s.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(s.sprfilter,tp,LOCATION_ONFIELD,0,nil)
	return g:CheckSubGroup(s.fselect1,2,2,tp,c) or g:CheckSubGroup(s.fselect2,2,2,tp,c)
end
function s.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(s.sprfilter,tp,LOCATION_ONFIELD,0,nil)
	b1=g:CheckSubGroup(s.fselect1,2,2,tp,c)
	b2=g:CheckSubGroup(s.fselect2,2,2,tp,c)
	local op=aux.SelectFromOptions(tp,{b1,1191},{b2,1102})
	e:SetLabel(op)
	local check=false
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:SelectSubGroup(tp,s.fselect1,true,2,2,tp,c)
		if sg then
			sg:KeepAlive()
			e:SetLabelObject(sg)
			check=true
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:SelectSubGroup(tp,s.fselect2,true,2,2,tp,c)
		if sg then
			sg:KeepAlive()
			e:SetLabelObject(sg)
			check=true
		end
	end
	if check then
		return true
	else return false end
end
function s.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	local op=e:GetLabel()
	if op==1 then
		Duel.SendtoGrave(g,REASON_SPSUMMON)
	else
		Duel.Remove(g,POS_FACEUP,REASON_SPSUMMON)
	end
	g:DeleteGroup()
end
function s.ptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCounter(tp,1,0,0x452)>0 and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
end
function s.pop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetCounter(tp,1,0,0x452)
	local tg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(tg) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(ct*500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function s.mtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id+1)==0 
		and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp)
	Duel.SetTargetParam(ac)
end
function s.mop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.HintSelection(g)
	local tc=g:GetFirst()
	if tc then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(ac)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		tc:RegisterEffect(e1)
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(s.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function s.splimit(e,c)
	return not aux.IsCodeListed(c,0x452)
end
function s.mcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x452,1,REASON_COST) end
	local ct=Duel.GetCounter(tp,1,0,0x452)
	local t={}
	for i=1,ct do
		table.insert(t,i)
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,6))
	local ac=Duel.AnnounceNumber(tp,table.unpack(t))
	Duel.RemoveCounter(tp,1,0,0x452,1,REASON_COST)
	e:SetLabel(ac)
end
function s.mtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,TYPE_SPELL+TYPE_TRAP) end
	Duel.RegisterFlagEffect(tp,id+1,RESET_PHASE+PHASE_END,0,1)
end
function s.mop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sg=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,TYPE_SPELL+TYPE_TRAP)
	if #sg>0 then
		Duel.HintSelection(sg)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
function s.mtg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct1=Duel.GetCounter(tp,1,0,0x452)
	local ct2=e:GetHandler():GetCounter(0x452)
	if chk==0 then return ct1>ct2 and Duel.IsCanRemoveCounter(tp,1,0,0x452,1,REASON_EFFECT) 
		and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
end
function s.mop3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if not Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true) then return end
	if Duel.IsCanRemoveCounter(tp,1,0,0x452,1,REASON_EFFECT) then
		Duel.BreakEffect()
		if Duel.RemoveCounter(tp,1,0,0x452,1,REASON_EFFECT) then
			if Duel.IsExistingMatchingCard(s.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)
				and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
				local g=Duel.SelectMatchingCard(tp,s.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
				if #g>0 then
					Duel.Summon(tp,g:GetFirst(),true,nil)
				end
			end
		end
	end
end
function s.sumfilter(c)
	return c:IsSetCard(0x5454) and c:IsSummonable(true,nil)
end