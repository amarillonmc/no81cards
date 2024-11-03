--《不详·征兆》荒诞剧
function c51900006.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,function(c) return c:IsFusionAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and c:IsRace(RACE_DRAGON+RACE_FAIRY) end,2,true)
	--draw 
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(51900006,4))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_PHASE+PHASE_END) 
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)  
	e1:SetTarget(c51900006.drtg)
	e1:SetOperation(c51900006.drop)
	c:RegisterEffect(e1) 
	--atk 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_SINGLE) 
	e2:SetCode(EFFECT_UPDATE_ATTACK) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetValue(function(e) 
	return e:GetHandler():GetMaterial():GetCount()*750 end) 
	c:RegisterEffect(e2) 
	--effect gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e2:SetCondition(c51900006.efcon)
	e2:SetOperation(c51900006.efop)
	c:RegisterEffect(e2) 
end
function c51900006.drtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end 
function c51900006.pcfil(c)
	return c:IsAttribute(ATTRIBUTE_DARK+ATTRIBUTE_LIGHT) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden() and (c:IsFaceup() or c:IsLocation(LOCATION_HAND))
end
function c51900006.eqfil(c,tp)
	return c:IsType(TYPE_EQUIP) and c:CheckUniqueOnField(tp) and not c:IsForbidden() and Duel.IsExistingMatchingCard(c51900006.eqtgfil,tp,LOCATION_MZONE,0,1,nil,c)
end
function c51900006.eqtgfil(c,eqc)
	return c:IsFaceup() and c:IsType(TYPE_FUSION) and eqc:CheckEquipTarget(c)
end
function c51900006.drop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM) 
	if Duel.Draw(p,d,REASON_EFFECT)~=0 then 
		local xtable={aux.Stringid(51900006,0)} 
		local b1=(Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and Duel.IsExistingMatchingCard(c51900006.pcfil,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil) 
		local b2=Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c51900006.eqfil,tp,LOCATION_HAND,0,1,nil,tp) 
		if b1 then table.insert(xtable,aux.Stringid(51900006,1)) end 
		if b2 then table.insert(xtable,aux.Stringid(51900006,2)) end  
		local op=Duel.SelectOption(tp,table.unpack(xtable))+1 
		if xtable[op]==aux.Stringid(51900006,1) then 
			local pc=Duel.SelectMatchingCard(tp,c51900006.pcfil,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil):GetFirst() 
			Duel.MoveToField(pc,tp,tp,LOCATION_PZONE,POS_FACEUP,true) 
		end 
		if xtable[op]==aux.Stringid(51900006,2) then 
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local ec=Duel.SelectMatchingCard(tp,c51900006.eqfil,tp,LOCATION_HAND,0,1,1,nil,tp):GetFirst()
			if ec then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
				local tc=Duel.SelectMatchingCard(tp,c51900006.eqtgfil,tp,LOCATION_MZONE,0,1,1,nil,ec):GetFirst()
				Duel.Equip(tp,ec,tc)
			end
		end 
	end 
end
function c51900006.efcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_FUSION 
end
function c51900006.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	rc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(51900006,3))
	--
	--draw 
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(51900006,4))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_PHASE+PHASE_END) 
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)  
	e1:SetTarget(c51900006.drtg)
	e1:SetOperation(c51900006.drop)
	rc:RegisterEffect(e1,true) 
	--atk 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_SINGLE) 
	e2:SetCode(EFFECT_UPDATE_ATTACK) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetValue(function(e) 
	return e:GetHandler():GetMaterial():GetCount()*750 end) 
	rc:RegisterEffect(e2,true) 
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e2,true)
	end
end









