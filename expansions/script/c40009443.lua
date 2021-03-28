--复血鬼-诛杀女王
function c40009443.initial_effect(c)
	--summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40009443,0))
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SUMMON_PROC)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,40009443)
	e2:SetCondition(c40009443.ntcon)
	e2:SetOperation(c40009443.ntop)
	c:RegisterEffect(e2)  
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c40009443.sumcon)
	e1:SetTarget(c40009443.sumtg)
	e1:SetOperation(c40009443.sumop)
	c:RegisterEffect(e1)
	if not c40009443.global_check then
		c40009443.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetLabel(40009443)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetOperation(aux.sumreg)
		Duel.RegisterEffect(ge1,0)
	end  
end
function c40009443.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:IsLevelAbove(5)
		and Duel.CheckLPCost(tp,800)
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c40009443.ntop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.PayLPCost(tp,800)
end
function c40009443.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(40009443)>0 and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end

function c40009443.sumfilter(c)
	return c:IsRace(RACE_ZOMBIE) and c:IsSummonable(true,nil,1) 
end
function c40009443.filter(c)
	return c:IsLevelAbove(6) and c:IsRace(RACE_ZOMBIE) and c:IsAbleToHand()
end
function c40009443.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40009443.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c40009443.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c40009443.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 and Duel.ConfirmCards(1-tp,g) then
		local tg=Duel.SelectMatchingCard(tp,c40009443.sumfilter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=tg:GetFirst()
	if tc and Duel.SelectYesNo(tp,aux.Stringid(40009443,1)) then
			Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		Duel.Summon(tp,tc,true,nil,1)
	end
		--if tg:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			---and Duel.SelectYesNo(tp,aux.Stringid(40009443,2)) then
		   --- Duel.BreakEffect()
		   -- Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		   -- local tc=tg:Select(tp,1,1,nil)
		   -- Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
	   -- end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c40009443.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	end
end
function c40009443.splimit(e,c)
	return not c:IsRace(RACE_ZOMBIE)
end


