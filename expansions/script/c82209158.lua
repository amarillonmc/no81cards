--炽金战兽 露茜妮
local m=82209158
local cm=c82209158
function cm.initial_effect(c)
	--common spsummon effect  
	local e0=Effect.CreateEffect(c)  
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)  
	e0:SetCode(EVENT_TO_GRAVE)  
	e0:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)  
	e0:SetCondition(cm.cmcon)  
	e0:SetTarget(cm.cmtg)  
	e0:SetOperation(cm.cmop)  
	c:RegisterEffect(e0)
	--negate  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,3))  
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)  
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1,m)  
	e1:SetCondition(cm.tkcon)
	e1:SetTarget(cm.tktg)  
	e1:SetOperation(cm.tkop)  
	c:RegisterEffect(e1)  
	--negate  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,4))  
	e2:SetCategory(CATEGORY_DISABLE)  
	e2:SetType(EFFECT_TYPE_QUICK_O)  
	e2:SetCode(EVENT_FREE_CHAIN)  
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)  
	e2:SetCountLimit(1,m+10000)
	e2:SetCondition(cm.negcon)
	e2:SetTarget(cm.negtg)  
	e2:SetOperation(cm.negop)  
	c:RegisterEffect(e2)  
end

--common
function cm.cmcon(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	return c:IsPreviousLocation(LOCATION_MZONE) 
			and bit.band(c:GetPreviousRaceOnField(),RACE_MACHINE)~=0 
			and c:IsPreviousPosition(POS_FACEUP) 
			and rp==1-tp and c:GetPreviousControler()==tp
end  
function cm.cmtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)  
end  
function cm.cmop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if c:IsRelateToEffect(e) then  
		if Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then 
			--change race
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(m,0))
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_RACE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			e1:SetValue(RACE_BEAST)
			c:RegisterEffect(e1)
			--change base attack
			local atk=c:GetBaseAttack()
			local e2=Effect.CreateEffect(c)
			e2:SetDescription(aux.Stringid(m,1))
			e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_SET_BASE_ATTACK)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			e2:SetValue(atk*2)
			c:RegisterEffect(e2)
			--redirect
			local e3=Effect.CreateEffect(c)  
			e3:SetDescription(aux.Stringid(m,2))
			e3:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetType(EFFECT_TYPE_SINGLE)  
			e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)  
			e3:SetReset(RESET_EVENT+RESETS_REDIRECT)  
			e3:SetValue(LOCATION_DECKBOT)  
			c:RegisterEffect(e3)  
			Duel.SpecialSummonComplete()
		end 
	end  
end  

--token
function cm.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsRace(RACE_MACHINE)
end
function cm.tkfilter(c)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsLevelBelow(4) and c:GetAttack()~=0
end
function cm.tktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and cm.tkfilter(chkc) end 
	if chk==0 then return Duel.IsExistingTarget(cm.tkfilter,tp,0,LOCATION_MZONE,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,82209159,0,0x4011,0,0,1,RACE_MACHINE,ATTRIBUTE_FIRE,POS_FACEUP_ATTACK) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTACK) 
	local tc=Duel.SelectTarget(tp,cm.tkfilter,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
	local lv=tc:GetLevel()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	if ft>lv then ft=lv end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,ft,0,0)  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ft,0,0)  
end
function cm.tkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if (not tc:IsRelateToEffect(e)) or tc:IsFacedown() or tc:IsImmuneToEffect(e) or tc:IsAttack(0) then return end
	--change atk
	local e1=Effect.CreateEffect(e:GetHandler())  
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)  
	e1:SetValue(0)  
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)  
	tc:RegisterEffect(e1)  
	--token
	local lv=tc:GetLevel()
	if not lv then return end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)  
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end  
	if ft>lv then ft=lv end
	if ft<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,82209159,0,0x4011,0,0,1,RACE_MACHINE,ATTRIBUTE_FIRE,POS_FACEUP_ATTACK) then return end 
	for i=1,ft do  
		local token=Duel.CreateToken(tp,82209159)  
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_ATTACK)  
	end  
	Duel.SpecialSummonComplete()
end

--negate
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsRace(RACE_BEAST)
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and aux.disfilter1(chkc) end  
	if chk==0 then return Duel.IsExistingTarget(aux.disfilter1,tp,0,LOCATION_ONFIELD,1,nil) end  
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)  
	local g=Duel.SelectTarget(tp,aux.disfilter1,tp,0,LOCATION_ONFIELD,1,1,nil)  
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)  
end  
function cm.negop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local tc=Duel.GetFirstTarget()  
	if ((tc:IsFaceup() and not tc:IsDisabled()) or tc:IsType(TYPE_TRAPMONSTER)) and tc:IsRelateToEffect(e) then  
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)  
		local e1=Effect.CreateEffect(c)  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
		e1:SetCode(EFFECT_DISABLE)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)  
		tc:RegisterEffect(e1)  
		local e2=Effect.CreateEffect(c)  
		e2:SetType(EFFECT_TYPE_SINGLE)  
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
		e2:SetCode(EFFECT_DISABLE_EFFECT)  
		e2:SetValue(RESET_TURN_SET)  
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)  
		tc:RegisterEffect(e2)  
		if tc:IsType(TYPE_TRAPMONSTER) then  
			local e3=Effect.CreateEffect(c)  
			e3:SetType(EFFECT_TYPE_SINGLE)  
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)  
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)  
			tc:RegisterEffect(e3)  
		end  
	end  
end  
