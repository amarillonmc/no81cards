--无限大伊吕波
function c65130321.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c65130321.matfilter,5,true)
	aux.AddContactFusionProcedure(c,c65130321.matfilter2,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_EXTRA,0,aux.tdcfop(c))
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c65130321.splimit)
	c:RegisterEffect(e1)
	--effect gain
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65130321,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c65130321.retcon)
	e2:SetCost(c65130321.retcost)
	e2:SetTarget(c65130321.rettg)
	e2:SetOperation(c65130321.retop)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c65130321.eftg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
end
function c65130321.matfilter(c)
	return c:IsAttack(878) and c:IsDefense(1157)
end
function c65130321.matfilter2(c)
	return (c:IsAbleToDeckAsCost() or c:IsOriginalCodeRule(65130304)) and (c:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) or c:IsLocation(LOCATION_EXTRA) and c:IsType(TYPE_PENDULUM) and c:IsFaceup())
end
function c65130321.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c65130321.eftg(e,c)
	return c:GetBaseAttack()==878 and c:GetBaseDefense()==1157
end
function c65130321.retcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and c:IsRelateToBattle() and bc:IsRelateToBattle()
end
function c65130321.retcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return (c:IsAbleToHandAsCost() or c:IsOriginalCodeRule(65130304)) end
	Duel.SendtoHand(c,nil,REASON_COST)
end
function c65130321.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end  
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler():GetBattleTarget(),1,0,0)
end
function c65130321.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c65130321.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	local p=bc:GetOwner()
	if bc:IsRelateToBattle() then   
		if Duel.SendtoHand(bc,nil,REASON_EFFECT)>0 and bc:IsLocation(LOCATION_HAND) and Duel.IsExistingMatchingCard(c65130321.spfilter,p,LOCATION_HAND,0,1,nil,e,p) and Duel.SelectYesNo(p,aux.Stringid(65130321,1))then
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_SPSUMMON)
			local tg=Duel.SelectMatchingCard(p,c65130321.spfilter,p,LOCATION_HAND,0,1,1,nil,e,p)
			local tc=tg:GetFirst()
			local tcode=tc:GetCode()
			Duel.SpecialSummon(tc,0,p,p,false,false,POS_FACEUP)
			local e0=Effect.CreateEffect(c)
			e0:SetType(EFFECT_TYPE_FIELD)
			e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e0:SetTargetRange(1,1)
			e0:SetTarget(c65130321.thlimit)
			e0:SetLabel(tcode)
			e0:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e0,tp)
		end
	end
end
function c65130321.thlimit(e,c)
	return c:IsCode(e:GetLabel())
end