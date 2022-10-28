--重醒龙 帝王剑斩
function c25000022.initial_effect(c)
	 --fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c25000022.ffilter,3,false)
	aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_MZONE,0,Duel.Release,REASON_COST+REASON_MATERIAL)  
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c25000022.splimit)
	c:RegisterEffect(e1)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(25000022,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,25000022)
	e1:SetCost(c25000022.atkcost)
	e1:SetTarget(c25000022.atktg)
	e1:SetOperation(c25000022.atkop)
	c:RegisterEffect(e1)
	--xx
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c25000022.xxcost)
	e2:SetTarget(c25000022.xxtg)
	e2:SetOperation(c25000022.xxop)
	c:RegisterEffect(e2)
end
function c25000022.ffilter(c,fc,sub,mg,sg)
	return ( not sg or sg:GetClassCount(Card.GetRace)==1) and c:IsFusionType(TYPE_FUSION)
end
function c25000022.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c25000022.ctfil(c)
	return c:IsAbleToGraveAsCost() and c:IsType(TYPE_MONSTER) and c:IsLevelAbove(1)
end
function c25000022.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c25000022.ctfil,tp,LOCATION_DECK,0,1,nil) end 
	local g=Duel.SelectMatchingCard(tp,c25000022.ctfil,tp,LOCATION_DECK,0,1,1,nil) 
	Duel.SendtoGrave(g,REASON_COST) 
	e:SetLabel(g:GetFirst():GetLevel())
end
function c25000022.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c25000022.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local x=e:GetLabel()
	if c:IsRelateToEffect(e) then 
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(x*100)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	end
end
function c25000022.xctfil(c)
	return c:IsAbleToRemoveAsCost()  
end
function c25000022.xxcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c25000022.xctfil,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c25000022.xctfil,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c25000022.xxtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=true 
	local b2=Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) 
	if chk==0 then return b1 or b2 end 
	local op=0
	if b1 and b2 then 
	op=Duel.SelectOption(tp,aux.Stringid(25000022,1),aux.Stringid(25000022,2))
	elseif b1 then 
	op=Duel.SelectOption(tp,aux.Stringid(25000022,1))   
	else 
	op=Duel.SelectOption(tp,aux.Stringid(25000022,2))+1 
	end
	e:SetLabel(op)
end
function c25000022.xtgfil(c,ec,tp) 
	local seq=ec:GetSequence()
	if ec:IsControler(tp) then 
		return math.abs(4-seq-c:GetSequence())<=1
	else
		return math.abs(seq-c:GetSequence())<=1
	end
end
function c25000022.xxop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=e:GetLabel()
	if op==0 then 
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SKIP_M1)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(0,1)
		if Duel.GetTurnPlayer()==1-tp and Duel.GetCurrentPhase()==PHASE_MAIN1 then
			e1:SetLabel(Duel.GetTurnCount())
			e1:SetCondition(c25000022.turncon)
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
		else
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
		end
		Duel.RegisterEffect(e1,tp)  
	else
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil) 
	if g:GetCount()<=0 then return end 
	local tc=g:Select(tp,1,1,nil):GetFirst()
	local dg=Duel.GetMatchingGroup(c25000022.xtgfil,tp,0,LOCATION_ONFIELD,nil,tc,tp)
	--dg:AddCard(tc)
	Duel.HintSelection(dg)
	Duel.SendtoGrave(dg,REASON_EFFECT)
	end
end
function c25000022.turncon(e)
	return Duel.GetTurnCount()~=e:GetLabel()
end


