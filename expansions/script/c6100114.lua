--凯茜娅-狂诗
local s, id = GetID()
function s.initial_effect(c)
	-- 连接怪兽定义
	aux.AddLinkProcedure(c,nil,3,5,s.lcheck)
	c:EnableReviveLimit()
	
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.rmcon)
	e2:SetOperation(s.rmop)
	c:RegisterEffect(e2)
	
	-- 效果③：连锁无效
	local e3 = Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id, 2))
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1, id)
	e3:SetCondition(s.dscon)
	e3:SetCost(s.dscost)
	e3:SetTarget(s.dstg)
	e3:SetOperation(s.dsop)
	c:RegisterEffect(e3)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_HAND)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end

-- 连接素材条件：包含从除外区特殊召唤的怪兽
function s.lcheck(g,lc)
	return g:IsExists(Card.IsSummonLocation,1,nil,LOCATION_REMOVED)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if tc:GetPreviousLocation()==LOCATION_REMOVED then
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
	end
end
function s.rmfilter(c)
	return c:IsSetCard(0xa61c) and c:IsFaceup() and (c:IsAbleToDeck() or c:IsAbleToExtra())
end

function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:GetHandler():IsLocation(LOCATION_HAND+LOCATION_GRAVE) and Duel.IsExistingMatchingCard(s.disfilter,tp,LOCATION_REMOVED,0,1,nil)  
end

function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(id,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tc=Duel.SelectMatchingCard(tp,s.rmfilter,tp,LOCATION_REMOVED,0,1,1,nil):GetFirst()
		if tc and Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT) then
			Duel.Hint(HINT_CARD,0,id)
			local sc=re:GetHandler()
			if c:GetFlagEffect(id)>0 then 
				Duel.NegateRelatedChain(sc,RESET_TURN_SET)
			if Duel.Remove(sc,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetLabelObject(sc)
			e1:SetCountLimit(1)
			e1:SetOperation(s.retop)
			Duel.RegisterEffect(e1,tp)
				else
				if Duel.Remove(sc,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetLabelObject(sc)
			e1:SetCountLimit(1)
			e1:SetOperation(s.retop)
			Duel.RegisterEffect(e1,tp)
				 end
				end
			end
		end
	end
end

function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetPreviousLocation()==LOCATION_HAND then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	else
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end

-- 效果③：条件检查 - 连锁2以后
function s.dscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>=2
end

function s.dscost(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return true end
   e:SetLabel(id)
end

-- 效果③：目标设置
function s.dstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_REMOVED,0,1,nil) end
		if Duel.GetFlagEffect(e:GetHandlerPlayer(),id)>0 then
		Duel.SetChainLimit(s.chainlm)
end
function s.chainlm(e,ep,tp)
	return tp==ep
end
-- 效果③：操作处理 - 无效化同名卡效果
function s.dsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,0))
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_REMOVED,nil)
	local c=e:GetHandler()
	local tc=g:GetFirst()
	if e:GetLabel() then
		while tc do
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTargetRange(0,LOCATION_ONFIELD)
		e1:SetTarget(s.distg1)
		e1:SetLabelObject(tc)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetCondition(s.discon)
		e2:SetOperation(s.disop)
		e2:SetLabelObject(tc)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
		Duel.RegisterEffect(e2,tp)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
		e3:SetTargetRange(0,LOCATION_MZONE)
		e3:SetTarget(s.distg2)
		e3:SetLabelObject(tc)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
		Duel.RegisterEffect(e3,tp)
		tc=g:GetNext()
		end
	end
end

function s.distg1(e,c)
	local tc=e:GetLabelObject()
	if c:IsType(TYPE_SPELL+TYPE_TRAP) then
		return c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
	else
		return c:IsOriginalCodeRule(tc:GetOriginalCodeRule()) and (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0)
	end
end
function s.distg2(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
