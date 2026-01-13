--空创融神 乌拉诺斯·至高进化
local s,id=GetID()
s.named_with_HighEvo = 1
function s.HighEvo(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_HighEvo
end
function s.initial_effect(c)


	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,40020509,aux.FilterBoolFunction(s.matfilter),1,true,true)
	
	--special summon condition
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(EFFECT_SPSUMMON_CONDITION)
	e5:SetRange(LOCATION_EXTRA)
	e5:SetValue(aux.fuslimit)
	c:RegisterEffect(e5)

	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(s.sprcon)
	e0:SetTarget(s.sprtg)
	e0:SetOperation(s.sprop)
	c:RegisterEffect(e0)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DISABLE + CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.distg)
	e1:SetOperation(s.disop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(s.drcon)
	e2:SetTarget(s.drtg)
	e2:SetOperation(s.drop)
	c:RegisterEffect(e2)
end


function s.matfilter(c,fc,sumtype,tp)
	return s.HighEvo(c) and c:IsType(TYPE_MONSTER,fc,sumtype,tp)
end


function s.spfilter(c)

	return (c:IsCode(40020509) or s.matfilter(c)) and c:IsCanBeFusionMaterial() and c:IsReleasable()
end

function s.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_ONFIELD,0,nil)
	return g:CheckSubGroup(s.fcheck,2,2)
end

function s.fcheck(g)
	return g:IsExists(Card.IsCode,1,nil,40020509) and g:IsExists(s.matfilter,1,nil)
end

function s.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_ONFIELD,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=g:SelectSubGroup(tp,s.fcheck,false,2,2)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	end
	return false
end

function s.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local sg=e:GetLabelObject()
	if not sg then return end
	Duel.Release(sg,REASON_COST+REASON_MATERIAL)
end

function s.disfilter(c)
	return c:IsFaceup() and not c:IsDisabled()
end

function s.trapfilter(c)
	return c:IsFacedown() and c:IsType(TYPE_TRAP) and s.HighEvo(c)
end

function s.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and s.disfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.disfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local g=Duel.SelectTarget(tp,s.disfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0)
end

function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	
	for tc in aux.Next(g) do
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
	

	local tg=Duel.GetMatchingGroup(s.trapfilter,tp,LOCATION_SZONE,0,nil)
	if tg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,3))

		local sg=tg:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		
		if not tc or not tc:IsFacedown() then return end

		Duel.ChangePosition(tc,POS_FACEUP)
		
		local te=tc:GetActivateEffect()
		if te then
			local teg,tep,tev,tre,tr,trp = nil,tp,0,nil,0,0
			

			local tg_func=te:GetTarget()
			if tg_func then
				tg_func(te,tp,teg,tep,tev,tre,tr,trp,1)
			end
			
			local op_func=te:GetOperation()
			if op_func then
				tc:CreateEffectRelation(te)
				op_func(te,tp,teg,tep,tev,tre,tr,trp)
				tc:ReleaseEffectRelation(te)
			end
		end
		

		if not tc:IsType(TYPE_CONTINUOUS) and not tc:IsType(TYPE_EQUIP) and not tc:IsHasEffect(EFFECT_REMAIN_FIELD) then
			Duel.SendtoGrave(tc,REASON_RULE)
		end
	end
end


function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsType(TYPE_TRAP) and rp==tp
end

function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0) 
end

function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)~=0 then
		local dc=Duel.GetOperatedGroup():GetFirst()

		Duel.ConfirmCards(1-tp,dc)

		if s.HighEvo(dc) then

			local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
			if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
				local sg=g:Select(tp,1,1,nil)
				Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
			end
		end
		Duel.ShuffleHand(tp)
	end
end
