--守护天使 雅尼耶尔
function c40009099.initial_effect(c)
	--summon with s/t
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e0:SetTargetRange(LOCATION_HAND,0)
	e0:SetTarget(function(e,c) return e:GetHandler()~=c and c:IsRace(RACE_FAIRY) and c:IsType(TYPE_MONSTER) end)
	e0:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e0)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009099,0))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c40009099.retg)
	e1:SetOperation(c40009099.reop)
	c:RegisterEffect(e1)
	--summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40009099,2))
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c40009099.sumtg)
	e2:SetOperation(c40009099.sumop)
	c:RegisterEffect(e2)	
end
function c40009099.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,PLAYER_ALL,1000)
	if (Duel.GetLP(e:GetHandlerPlayer())>=10000 or Duel.GetLP(1-tp)>=10000) then
		e:SetCategory(CATEGORY_RECOVER+CATEGORY_TOHAND+CATEGORY_SEARCH)
		e:SetLabel(1)
	else
		e:SetCategory(CATEGORY_RECOVER)
		e:SetLabel(0)
	end
end
function c40009099.filter(c)
	return c:IsSetCard(0xf27) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c40009099.reop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Recover(tp,1000,REASON_EFFECT)~=0 and Duel.Recover(1-tp,1000,REASON_EFFECT)~=0 and e:GetLabel()==1 and Duel.IsExistingMatchingCard(c40009099.filter,tp,LOCATION_DECK,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(40009099,1)) then
		Duel.BreakEffect()
		local g=Duel.SelectMatchingCard(tp,c40009099.filter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
		   Duel.SendtoHand(g,nil,REASON_EFFECT)
		   Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c40009099.sumfilter(c)
	return c:IsSetCard(0xf27) and c:IsSummonable(true,nil)
end
function c40009099.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40009099.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c40009099.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c40009099.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end 