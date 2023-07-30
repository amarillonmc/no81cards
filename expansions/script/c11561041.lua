--尼德霍格
function c11561041.initial_effect(c) 
	--xyz summon
	aux.AddXyzProcedure(c,nil,10,2)
	c:EnableReviveLimit()
	--pos
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_POSITION) 
	e1:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e1) 
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2) 
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e2:SetCondition(c11561041.xdamcon)
	e2:SetOperation(c11561041.xdamop)
	c:RegisterEffect(e2)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11561041,1))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F) 
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,11561041) 
	e2:SetTarget(c11561041.damtg)
	e2:SetOperation(c11561041.damop)
	c:RegisterEffect(e2) 
	--xx
	local e3=Effect.CreateEffect(c) 
	e3:SetDescription(aux.Stringid(11561041,2))
	e3:SetCategory(CATEGORY_DESTROY) 
	e3:SetType(EFFECT_TYPE_QUICK_O) 
	e3:SetCode(EVENT_FREE_CHAIN) 
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e3:SetRange(LOCATION_MZONE) 
	e3:SetCountLimit(1,21561041)  
	e3:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST) end) 
	e3:SetTarget(c11561041.xxtg) 
	e3:SetOperation(c11561041.xxop) 
	c:RegisterEffect(e3) 
end
function c11561041.xdamcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep==tp 
end
function c11561041.xdamop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	Duel.ChangeBattleDamage(ep,0) 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_UPDATE_DEFENSE) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetValue(-ev) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
	c:RegisterEffect(e1) 
	if c:GetDefense()==0 then 
		Duel.Remove(c,POS_FACEUP,REASON_EFFECT) 
	else 
		Duel.Damage(1-tp,ev,REASON_EFFECT)   
	end 
end
function c11561041.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,tp,500)
end
function c11561041.damop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT) 
	if c:IsRelateToEffect(e) then 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_UPDATE_ATTACK) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(d) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		c:RegisterEffect(e1)		  
	end 
end
function c11561041.xxtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end 
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end 
function c11561041.xxop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) then 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_UPDATE_ATTACK) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(-c:GetAttack()) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		tc:RegisterEffect(e1) 
		if tc:IsAttack(0) then 
			Duel.Destroy(tc,REASON_EFFECT) 
		else 
			--cannot release
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetCode(EFFECT_UNRELEASABLE_SUM)
			e1:SetRange(LOCATION_MZONE)
			e1:SetValue(1) 
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
			tc:RegisterEffect(e2)
			local e3=e1:Clone()
			e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
			e3:SetValue(function(e,c,sumtype)
			return sumtype==SUMMON_TYPE_FUSION end) 
			tc:RegisterEffect(e3)
			local e4=e1:Clone()
			e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
			tc:RegisterEffect(e4)
			local e5=e1:Clone()
			e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
			tc:RegisterEffect(e5)   
			local e6=e1:Clone()
			e6:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
			tc:RegisterEffect(e6) 
		end  
		if c:IsRelateToEffect(e) then 
			local e1=Effect.CreateEffect(c) 
			e1:SetType(EFFECT_TYPE_SINGLE) 
			e1:SetCode(EFFECT_CANNOT_ATTACK) 
			e1:SetRange(LOCATION_MZONE)  
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)   
			c:RegisterEffect(e1)  
		end   
	end 
end 















