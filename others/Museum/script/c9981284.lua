--骑士时刻Buid·天才形态2018
function c9981284.initial_effect(c)
	 --link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xbca),3)
	c:EnableReviveLimit()
	--cannot target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	--extra att
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EXTRA_ATTACK)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--damage reduce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetValue(HALF_DAMAGE)
	c:RegisterEffect(e2)
	--pierce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e2)
	--reflect damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_REFLECT_DAMAGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(c9981284.refcon)
	c:RegisterEffect(e1)
	--battle indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e3:SetCountLimit(2)
	e3:SetValue(c9981284.valcon)
	c:RegisterEffect(e3)
	 --destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9981284,0))
	e1:SetCategory(CATEGORY_DICE+CATEGORY_ATKCHANGE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c9981284.target)
	e1:SetOperation(c9981284.operation)
	c:RegisterEffect(e1)
	 --destroy & damage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetDescription(aux.Stringid(9981284,3))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetTarget(c9981284.target2)
	e2:SetOperation(c9981284.operation2)
	c:RegisterEffect(e2)
	--atk/def
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetValue(c9981284.adval)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e7)
	--apply effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9981284,0))
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_RECOVER+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,9981284)
	e1:SetCondition(c9981284.condition)
	e1:SetTarget(c9981284.target3)
	e1:SetOperation(c9981284.operation3)
	c:RegisterEffect(e1)
   --spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9981284.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9981284.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981284,0))
end
function c9981284.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,3)
	Duel.SetChainLimit(c9981284.chainlm)
end
function c9981284.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local d1,d2,d3=Duel.TossDice(tp,3)
	local atk=(d1+d2+d3)*100
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(atk)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END,2)
	c:RegisterEffect(e1)
	local res12=false
	local res34=false
	local res56=false
	if d1==d2 and d2==d3 then
		res12=true
		res34=true
		res56=true
	elseif (d1==d2 and (d1==1 or d1==2)) or (d1==d3 and (d1==1 or d1==2)) or (d2==d3 and (d2==1 or d2==2)) then
		res12=true
	elseif (d1==d2 and (d1==3 or d1==4)) or (d1==d3 and (d1==3 or d1==4)) or (d2==d3 and (d2==3 or d2==4)) then
		res34=true
	elseif (d1==d2 and (d1==5 or d1==6)) or (d1==d3 and (d1==5 or d1==6)) or (d2==d3 and (d2==5 or d2==6)) then
		res56=true
	end
	if not res12 and not res34 and not res56 then return end
	Duel.BreakEffect()
	if res12 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		c:RegisterEffect(e2)
	end
	if res34 then
		Duel.Draw(tp,2,REASON_EFFECT)
	end
	if res56 then
		local e3=Effect.CreateEffect(c)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DIRECT_ATTACK)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e3)
	end
Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981284,1))
end
function c9981284.adval(e,c)
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_GRAVE,0)*100
end
function c9981284.refcon(e,re,val,r,rp,rc)
	return bit.band(r,REASON_EFFECT)~=0 and rp==1-e:GetHandlerPlayer()
end
function c9981284.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
function c9981284.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	if g:GetFirst():IsType(TYPE_MONSTER) then
		local atk=g:GetFirst():GetTextAttack()
		if atk<0 then atk=0 end
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk)
	end
 Duel.SetChainLimit(c9981284.chainlm)
end
function c9981284.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsControler(1-tp) then
		local atk=tc:GetTextAttack()
		if atk<0 then atk=0 end
		if Duel.Destroy(tc,REASON_EFFECT)~=0 and tc:IsType(TYPE_MONSTER) then
			Duel.BreakEffect()
			Duel.Damage(1-tp,atk,REASON_EFFECT)
		end
	end
end
function c9981284.chainlm(e,ep,tp)
	return tp==ep
end
function c9981284.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c9981284.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAttribute,tp,LOCATION_GRAVE+LOCATION_MZONE,0,nil,ATTRIBUTE_LIGHT+ATTRIBUTE_DARK+ATTRIBUTE_WATER+ATTRIBUTE_WIND+ATTRIBUTE_FIRE+ATTRIBUTE_EARTH)
	if chk==0 then return #g>0 and (g:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_DARK)<#g or Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) or Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,e:GetHandler())) end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_LIGHT)*300)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_WATER)*400)
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,g:FilterCount(Card.IsAttribute,tp,nil,ATTRIBUTE_EARTH),LOCATION_HAND)
	Duel.SetChainLimit(c9981284.chainlm)
end
function c9981284.operation3(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetMatchingGroup(Card.IsAttribute,tp,LOCATION_GRAVE+LOCATION_MZONE,0,nil,ATTRIBUTE_LIGHT+ATTRIBUTE_DARK+ATTRIBUTE_WATER+ATTRIBUTE_WIND+ATTRIBUTE_FIRE+ATTRIBUTE_EARTH)
	if #g==0 then return end
	local c=e:GetHandler()
	local ct1=g:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_LIGHT)
	local ct2=g:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_DARK)
	local ct3=g:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_WIND)
	local ct4=g:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_WATER)
	local ct5=g:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_FIRE)
	local ct6=g:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_EARTH)
	if ct1>0 then
		Duel.Damage(1-tp,ct1*300,REASON_EFFECT)
	end
	if ct2>0 and c:IsFaceup() and c:IsRelateToEffect(e) then
		if ct1>0 then Duel.BreakEffect() end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(ct2*200)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
	local og=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if ct3>0 and #og>0 then
		if ct1>0 or ct2>0 then Duel.BreakEffect() end
		for tc in aux.Next(og) do
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetValue(ct3*-300)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
		end
	end
	if ct4>0 then
		if ct1>0 or ct2>0 or ct3>0 then Duel.BreakEffect() end
		Duel.Recover(tp,ct4*400,REASON_EFFECT)
	end
	local og1=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	if ct5>0 and #og1>0 then
		if ct1>0 or ct2>0 or ct3>0 or ct4>0 then Duel.BreakEffect() end
		for tc in aux.Next(og1) do
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetValue(ct5*300)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
		end
	end
	if ct6>0 then
		if ct1>0 or ct2>0 or ct3>0 or ct4>0 or ct5>0 then Duel.BreakEffect() end
		Duel.Draw(p,ct6+1,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
		local og2=Duel.SelectMatchingCard(p,Card.IsAbleToDeck,p,LOCATION_HAND,0,ct6,ct6,nil)
		local ct6=Duel.SendtoDeck(og2,nil,2,REASON_EFFECT)
		Duel.ShuffleDeck(p)
	end
end
