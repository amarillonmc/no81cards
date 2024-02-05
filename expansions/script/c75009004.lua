--暗杀还是美人计？ 卡米拉
function c75009004.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_CHAINING) 
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,75009004)
	e1:SetCondition(c75009004.spcon)
	e1:SetTarget(c75009004.sptg)
	e1:SetOperation(c75009004.spop)
	c:RegisterEffect(e1) 
	--atk limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetValue(function(e,c)
	return e:GetHandler():GetLevel()>c:GetLevel() and c:IsLevelAbove(1) end)  
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetTarget(function(e,c)
	return c:IsLevelAbove(1) end)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3) 
	--damage 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_BATTLE_START)   
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(function(e)
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer() end)
	e3:SetTarget(c75009004.damtg)
	e3:SetOperation(c75009004.damop)
	c:RegisterEffect(e3)
end
function c75009004.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsLocation(LOCATION_MZONE) 
end
function c75009004.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c75009004.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true) 
		--indes
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT) 
		e2:SetRange(LOCATION_MZONE)
		e2:SetValue(1)  
		e2:SetReset(RESET_EVENT+RESETS_REDIRECT)
		c:RegisterEffect(e2) 
	end
end
function c75009004.tarfil(c,e) 
	return c:IsFaceup() and c:IsCanBeEffectTarget(e) 
end 
function c75009004.targck(g) 
	return g:GetClassCount(Card.GetAttack)==g:GetCount()   
end  
function c75009004.damtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(c75009004.tarfil,tp,0,LOCATION_MZONE,nil,e)
	if chk==0 then return g:CheckSubGroup(c75009004.targck,2,2) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local sg=g:SelectSubGroup(tp,c75009004.targck,false,2,2)   
	Duel.SetTargetCard(sg) 
	Duel.SetTargetPlayer(1-tp)
	local tc1=sg:GetFirst() 
	local tc2=sg:GetNext()   
	local xatk=math.abs(tc1:GetAttack()-tc2:GetAttack()) 
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,xatk)
end 
function c75009004.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER) 
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e) 
	if g:GetCount()==2 then 
		local tc1=g:GetFirst() 
		local tc2=g:GetNext()   
		local xatk=math.abs(tc1:GetAttack()-tc2:GetAttack())  
		if xatk>0 then 
			Duel.Damage(p,xatk,REASON_EFFECT) 
		end  
	end 
end 






