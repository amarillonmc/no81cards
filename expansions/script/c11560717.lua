--星海航线 无限自由
function c11560717.initial_effect(c)
	 --xyz summon
	aux.AddXyzProcedure(c,nil,12,3,c11560717.ovfilter,aux.Stringid(11560717,0),3,c11560717.xyzop)
	c:EnableReviveLimit() 
	--actlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(1)
	e1:SetCondition(function(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler() end)
	c:RegisterEffect(e1)   
	--coin 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCondition(c11560717.cncon)	
	e1:SetOperation(c11560717.cnop) 
	c:RegisterEffect(e1) 
	--dam 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLED) 
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET) 
	e2:SetCountLimit(1) 
	e2:SetTarget(c11560717.damtg)
	e2:SetOperation(c11560717.damop)
	c:RegisterEffect(e2) 
	--to grave 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_QUICK_O) 
	e3:SetCode(EVENT_FREE_CHAIN) 
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER) 
	e3:SetCountLimit(1,11560717)  
	e3:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST) end)
	e3:SetTarget(c11560717.tgtg) 
	e3:SetOperation(c11560717.tgop) 
	c:RegisterEffect(e3) 
	Duel.AddCustomActivityCounter(11560717,ACTIVITY_CHAIN,c11560717.chainfilter)
end
c11560717.SetCard_SR_Saier=true  
c11560717.toss_coin=true 
function c11560717.chainfilter(re,tp,cid)
	local rc=re:GetHandler() 
	return not (re:IsActiveType(TYPE_MONSTER) and rc.SetCard_SR_Saier)
end
function c11560717.ovfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) 
end
function c11560717.xyzop(e,tp,chk,mc)
	if chk==0 then return Duel.GetFlagEffect(tp,11560717)==0 and Duel.GetCustomActivityCount(11560717,tp,ACTIVITY_CHAIN)~=0 and mc:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	mc:RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.RegisterFlagEffect(tp,11560717,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c11560717.cncon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local ac=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	return ((ac and c==ac) or (bc and c==bc))   
end
function c11560717.cnop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local x=Duel.TossCoin(tp,1)
	if x==1 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(c:GetAttack()*2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
		c:RegisterEffect(e1)
	elseif x==0 and c:GetBaseDefense()>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(c:GetBaseDefense())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
		c:RegisterEffect(e1)
	end
end
function c11560717.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
	Duel.SetTargetPlayer(1-tp) 
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,e:GetHandler():GetBaseAttack()/2)
end
function c11560717.damop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local atk=c:GetBaseAttack() 
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	if c:IsRelateToEffect(e) and atk>0 then 
		Duel.Damage(p,atk/2,REASON_EFFECT)   
	end 
end 
function c11560717.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_ONFIELD) 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0) 
end
function c11560717.tgop(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,nil) 
	if g:GetCount()>0 then 
		local tc=g:Select(tp,1,1,nil):GetFirst() 
		local dg=Group.FromCards(c,tc) 
		Duel.SendtoGrave(dg,REASON_EFFECT) 
		if Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(11560717,1)) then 
			local sc=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil):GetFirst() 
			--coin 
			local e1=Effect.CreateEffect(sc) 
			e1:SetDescription(aux.Stringid(11560717,2))
			e1:SetCategory(CATEGORY_ATKCHANGE)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_ATTACK_ANNOUNCE) 
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetRange(LOCATION_MZONE) 
			e1:SetCondition(c11560717.cncon)	
			e1:SetOperation(c11560717.cnop) 
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e1) 
			--dam 
			local e2=Effect.CreateEffect(sc) 
			e2:SetCategory(CATEGORY_DAMAGE)
			e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
			e2:SetCode(EVENT_BATTLED) 
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET) 
			e2:SetCountLimit(1) 
			e2:SetTarget(c11560717.damtg)
			e2:SetOperation(c11560717.damop) 
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e2) 
		end 
	end 
end 










