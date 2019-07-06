--扭曲的悲愿
function c33700022.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c33700022.cost)
	e1:SetTarget(c33700022.target)
	e1:SetOperation(c33700022.activate)
	c:RegisterEffect(e1)
end
function c33700022.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,nil,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,nil,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c33700022.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) and  Duel.IsPlayerCanSpecialSummonMonster(tp,33700032,0x1440,0x4011,0,0,1,RACE_FIEND,ATTRIBUTE_LIGHT) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c33700022.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFirstTarget()
	if g:IsRelateToEffect(e) and Duel.Destroy(g,REASON_EFFECT)>0 and  Duel.IsPlayerCanSpecialSummonMonster(tp,33700032,0x6440,0x4011,0,0,lv,RACE_FIEND,ATTRIBUTE_LIGHT) then
	Duel.BreakEffect()
	local token=Duel.CreateToken(tp,33700032)
	if Duel.SelectYesNo(tp,aux.Stringid(33700022,0)) then
	if Duel.SpecialSummon(token,0,tp,1-tp,false,false,POS_FACEUP)>0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_RACE)
			if g:IsHasEffect(EFFECT_ADD_RACE) and not g:IsHasEffect(EFFECT_CHANGE_RACE) then
				e1:SetValue(g:GetOriginalRace())
			else
				e1:SetValue(g:GetRace())
			end
			e1:SetReset(RESET_EVENT+0x1ff0000)
			token:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
			if g:IsHasEffect(EFFECT_ADD_ATTRIBUTE) and not g:IsHasEffect(EFFECT_CHANGE_ATTRIBUTE) then
				e2:SetValue(g:GetOriginalAttribute())
			else
				e2:SetValue(g:GetAttribute())
			end
			e2:SetReset(RESET_EVENT+0x1ff0000)
			token:RegisterEffect(e2)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_SET_ATTACK)
			e3:SetValue(g:GetAttack())
			e3:SetReset(RESET_EVENT+0x1ff0000)
			token:RegisterEffect(e3)
			local e4=e3:Clone()
			e4:SetCode(EFFECT_SET_DEFENSE)
			e4:SetValue(g:GetDefense())
			token:RegisterEffect(e4)
			local e5=Effect.CreateEffect(e:GetHandler())
			e5:SetType(EFFECT_TYPE_SINGLE)
			e5:SetCode(EFFECT_CHANGE_LEVEL)
			if g:IsType(TYPE_XYZ) then 
			e5:SetValue(g:GetRank())
			else
			e5:SetValue(g:GetLevel())
			end
			e5:SetReset(RESET_EVENT+0x1ff0000)
			token:RegisterEffect(e5)
			local e6=Effect.CreateEffect(e:GetHandler())
			e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
			e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e6:SetCode(EVENT_LEAVE_FIELD)
			e6:SetOperation(c33700022.leave)
			token:RegisterEffect(e6)
		end
	else
	 if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)>0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_RACE)
			if g:IsHasEffect(EFFECT_ADD_RACE) and not g:IsHasEffect(EFFECT_CHANGE_RACE) then
				e1:SetValue(g:GetOriginalRace())
			else
				e1:SetValue(g:GetRace())
			end
			e1:SetReset(RESET_EVENT+0x1ff0000)
			token:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
			if g:IsHasEffect(EFFECT_ADD_ATTRIBUTE) and not g:IsHasEffect(EFFECT_CHANGE_ATTRIBUTE) then
				e2:SetValue(g:GetOriginalAttribute())
			else
				e2:SetValue(g:GetAttribute())
			end
			e2:SetReset(RESET_EVENT+0x1ff0000)
			token:RegisterEffect(e2)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_SET_ATTACK)
			e3:SetValue(g:GetAttack())
			e3:SetReset(RESET_EVENT+0x1ff0000)
			token:RegisterEffect(e3)
			local e4=e3:Clone()
			e4:SetCode(EFFECT_SET_DEFENSE)
			e4:SetValue(g:GetDefense())
			token:RegisterEffect(e4)
			local e5=Effect.CreateEffect(e:GetHandler())
			e5:SetType(EFFECT_TYPE_SINGLE)
			e5:SetCode(EFFECT_CHANGE_LEVEL)
			if g:IsType(TYPE_XYZ) then 
			e5:SetValue(g:GetRank())
			else
			e5:SetValue(g:GetLevel())
			end
			e5:SetReset(RESET_EVENT+0x1ff0000)
			token:RegisterEffect(e5)
			local e6=Effect.CreateEffect(e:GetHandler())
			e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
			e6:SetCode(EVENT_LEAVE_FIELD)
			e6:SetOperation(c33700022.leave)
			token:RegisterEffect(e6,true)
		end
end
	end
end
function c33700022.leave(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Damage(c:GetPreviousControler(),c:GetPreviousAttackOnField(),REASON_EFFECT)
	e:Reset()
end