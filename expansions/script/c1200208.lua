--数字冥魂[冥界之门]=存储系统
--1200208
local supercode=1200205 -- =登录系统卡号
local s,id,o=GetID()
function s.initial_effect(c)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,1))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(s.handcon)
	c:RegisterEffect(e0)
	--load effect
	local le0=e0:Clone()
	le0:SetDescription(aux.Stringid(supercode,1))
	le0:SetCondition(s.sphandcon)
	c:RegisterEffect(le0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_END_PHASE,TIMING_END_PHASE)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--skip
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(1,0)
	e2:SetCode(EFFECT_SKIP_M2)
	c:RegisterEffect(e2)
	--immue
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_ONFIELD,0)
	e3:SetCondition(s.indcon)
	e3:SetTarget(s.indtg)
	e3:SetValue(s.efilter)
	c:RegisterEffect(e3)
	--inactivatable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_INACTIVATE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetValue(s.efilter2)
	c:RegisterEffect(e4)
	--return to hand and summon
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetDescription(1104)
	e5:SetCategory(CATEGORY_SUMMON+CATEGORY_TOHAND)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(s.rttg)
	e5:SetOperation(s.rtop)
	c:RegisterEffect(e5)
	--load effect
	local le5=e5:Clone()
	le5:SetDescription(aux.Stringid(supercode,1))
	le5:SetType(EFFECT_TYPE_QUICK_O)
	le5:SetCode(EVENT_CHAINING)
	le5:SetCondition(s.qcon)
	c:RegisterEffect(le5)
	
end
s.has_text_type=TYPE_SPIRIT
function s.handcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_END
end

function s.PlayerHint(e,tp,num)

	local he=Effect.CreateEffect(e:GetHandler())
	he:SetReset(RESET_PHASE+PHASE_END)
	he:SetDescription(aux.Stringid(id,num))
	he:SetType(EFFECT_TYPE_FIELD)
	he:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	he:SetTargetRange(1,0)
	Duel.RegisterEffect(he,tp)

end

function s.rfilter(c,tp)
	return (c:IsControler(tp) or c:IsFaceup())
		and c:IsType(TYPE_SPIRIT)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:SetLabel(-1)
	if Duel.CheckReleaseGroup(tp,s.rfilter,1,nil,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(id,5)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=Duel.SelectReleaseGroup(tp,s.rfilter,1,1,nil,tp)
		e:SetLabel(1)
		Duel.Release(g,REASON_COST)
	end
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	--e:SetLabel({e:GetLabel[1],0})
	local num=e:GetLabel()
	e:SetLabel(num,0)
	if chk==0 then return true end
	local g=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	if e:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) then
		e:SetLabel(num,100)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	--if Duel.GetFlagEffect(tp,id+1)~=0 then return end
	local g=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0)
	local num1,num2=e:GetLabel()
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		--Duel.RegisterFlagEffect(tp,id+1,RESET_PHASE+PHASE_END,0,1)
	end
	
	if num1>0 then
		--Duel.Recover(tp,num1,REASON_EFFECT)
		if Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
		--Duel.RegisterFlagEffect(tp,id+1,RESET_PHASE+PHASE_END,0,1)
	end
	if num2 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(id,2))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e1:SetTargetRange(1,0)
		e1:SetCode(EFFECT_SKIP_M2)
		Duel.RegisterEffect(e1,tp)
	end
end

function s.indcon(e)
	return Duel.GetCurrentPhase()==PHASE_STANDBY
end
function s.indtg(e,c)
	return c:IsType(TYPE_SPIRIT) or c:IsSetCard(0x6240)
end
function s.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end

function s.efilter2(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	local tc=te:GetHandler()
	return te:IsActiveType(TYPE_MONSTER) and tc:IsType(TYPE_SPIRIT) and s.indcon(e)
end

function s.rttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id+2)==0 end
end
function s.rtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.SendtoHand(c,nil,REASON_EFFECT)>0 and Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)==0
			and Duel.IsExistingMatchingCard(s.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,e,tp)
			and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			local g=Duel.SelectMatchingCard(tp,s.sumfilter,tp,LOCATION_HAND	+LOCATION_MZONE,0,1,1,nil,e,tp)
			local tc=g:GetFirst()
			if tc then
				Duel.Summon(tp,tc,true,nil)
			end
		end
	end
	--Infinite hand
	--Debug.Message(1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_HAND_LIMIT)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(0xff)
	e1:SetTargetRange(1,0)
	e1:SetValue(10)
	e1:Reset(RESET_PHASE+PHASE_END,2)
	c:RegisterEffect(e1)
	s.PlayerHint(e,tp,8)
	Duel.RegisterFlagEffect(tp,id+2,RESET_PHASE+PHASE_END,0,1)
end
function s.sumfilter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsSummonable(true,nil) and c:IsType(TYPE_SPIRIT)
		and not c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.qcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,supercode)>0 and ep~=tp
end

function s.sphandcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	if Duel.GetFlagEffect(tp,supercode)<=0 or Duel.GetCurrentChain()<=0 then return false end
	local p=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_PLAYER)
	return Duel.GetFlagEffect(tp,supercode)>0 and p~=tp
end