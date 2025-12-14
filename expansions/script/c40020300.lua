--天觉龙 潘奇
local s,id=GetID()

s.named_with_AwakenedDragon=1
function s.AwakenedDragon(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_AwakenedDragon
end
function s.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetTargetRange(1,0)
	e0:SetTarget(s.splimit)
	c:RegisterEffect(e0)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOEXTRA+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id) 
	e1:SetCost(s.excost)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.bkcon)
	e2:SetTarget(s.bktg)
	e2:SetOperation(s.bkop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e3)
end
function s.splimit(e,c,tp,sumtp,sumpos)
	return not s.AwakenedDragon(c) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end

-- 把单卡 c 当作灵摆卡使用加入额外
function s.SendToExtraAsPendulum(c,tp,reason,e)
	if not c then return end
	local handler = e and e:GetHandler() or nil
	if not c:IsType(TYPE_PENDULUM) then
		local e1=Effect.CreateEffect(handler)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetValue(TYPE_PENDULUM)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1,true)
	end
	Duel.SendtoExtraP(c,tp,reason)
end
function s.excost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return  not c:IsForbidden()
			
	end
	s.SendToExtraAsPendulum(c,tp,REASON_COST,e)
end
function s.thfilter(c)
	return c:IsFaceup()
		and (s.AwakenedDragon(c) or c:IsCode(40020256))
		and c:IsAbleToHand()	  
		and not c:IsCode(id) 
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_EXTRA,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
local function lrvalue(c)
	if c:IsType(TYPE_XYZ) then
		return c:GetRank()
	elseif c:IsType(TYPE_LINK) then
		return c:GetLink()
	else
		return c:GetLevel()
	end
end
function s.bkcon(e,tp,eg,ep,ev,re,r,rp)
	local tp2=e:GetHandlerPlayer()
	if e:IsHasType(EFFECT_TYPE_XMATERIAL) then
		local c=e:GetHandler()
		local rc=c:GetOverlayTarget()
		if not rc or not s.AwakenedDragon(rc) or not rc:IsType(TYPE_XYZ) then
			return false
		end
	end
	local ac=Duel.GetAttacker()
	return ac and ac:IsControler(tp2)
		and ac:IsLocation(LOCATION_MZONE)
		and s.AwakenedDragon(ac)
end
function s.tdfilter(c,limit,tp)
	if not (c:IsControler(1-tp) and c:IsOnField() and c:IsAbleToDeck()) then
		return false
	end
	if c:IsType(TYPE_MONSTER) then
		local v=lrvalue(c)
		return v>0 and v<=limit
	else
		return c:IsType(TYPE_SPELL+TYPE_TRAP)
	end
end
function s.bktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tp2=e:GetHandlerPlayer()
	local ac=Duel.GetAttacker()
	if not ac then return false end
	local limit=lrvalue(ac)   
	if chkc then
		return chkc:IsControler(1-tp2) and chkc:IsOnField()
			and s.tdfilter(chkc,limit,tp2)
	end
	if chk==0 then
		return Duel.IsExistingTarget(s.tdfilter,tp2,0,LOCATION_ONFIELD,1,nil,limit,tp2)
	end
	Duel.Hint(HINT_SELECTMSG,tp2,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp2,s.tdfilter,tp2,0,LOCATION_ONFIELD,1,1,nil,limit,tp2)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function s.bkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end