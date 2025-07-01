--白桃桃子-粉红偶像-
--Duel.LoadScript("c60000228.lua")
local cm,m,o=GetID()
function cm.initial_effect(c)
	c:SetSPSummonOnce(m)
	--link summon
	local e0=aux.AddLinkProcedure(c,cm.matfil,1,1)
	e0:SetProperty(e0:GetProperty()|EFFECT_FLAG_SET_AVAILABLE)
	c:EnableReviveLimit()
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_COST)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCost(cm.spcost)
	c:RegisterEffect(e0)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(73539069,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.thcon1)
	e1:SetTarget(cm.thtg1)
	e1:SetOperation(cm.thop1)
	c:RegisterEffect(e1)
	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCondition(cm.sumcon)
	e1:SetTarget(cm.tdtg)
	e1:SetOperation(cm.tdop)
	c:RegisterEffect(e1)
end
function cm.matfil(c)
	return c:IsLinkType(TYPE_FLIP)
end
function cm.ffil(c)
	return c:IsCode(60000228) and c:IsFaceup()
end
function cm.spcost(e,c,tp,st)
	if bit.band(st,SUMMON_TYPE_LINK)~=SUMMON_TYPE_LINK then return true end
	return Duel.IsExistingMatchingCard(cm.ffil,tp,LOCATION_FZONE,0,1,nil)
end

function cm.filter(c)
	return c:IsSetCard(0x3624) and (c:IsAbleToHand() or c:IsAbleToGrave()) and (c:IsType(TYPE_FLIP) or c:IsType(TYPE_TUNER))
end
function cm.thcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.spcheck(g)
	return aux.gffcheck(g,Card.IsAbleToHand,nil,Card.IsAbleToGrave,nil) and aux.gffcheck(g,Card.IsType,TYPE_FLIP,Card.IsType,TYPE_TUNER)
end
function cm.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return g:CheckSubGroup(cm.spcheck,2,2,g) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.thop1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil)
	if g:CheckSubGroup(cm.spcheck,2,2,g) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local hg=g:SelectSubGroup(tp,cm.spcheck,false,2,2)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local hg1=hg:Select(tp,1,1,nil)
		hg:Sub(hg1)
		if Duel.SendtoHand(hg1,nil,REASON_EFFECT)~=0 and Duel.SendtoGrave(hg,REASON_EFFECT)~=0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
			e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e1:SetTargetRange(1,0)
			e1:SetTarget(cm.splimit)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x3624) and c:IsLocation(LOCATION_EXTRA)
end
function cm.tdfil(c)
	return (c:IsLocation(LOCATION_HAND) and not c:IsPublic())
		or (c:IsLocation(LOCATION_MZONE) and c:IsFacedown())
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tdfil,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)
	and #Duel.GetDecktopGroup(tp,1)~=0 and e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dg=Duel.GetDecktopGroup(tp,1)
	if Duel.SendtoGrave(dg,REASON_EFFECT)~=0 and Duel.SendtoDeck(c,nil,1,REASON_EFFECT)~=0 then
		local g=Duel.GetMatchingGroup(cm.tdfil,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if tc:IsLocation(LOCATION_MZONE) then
			Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
		elseif tc:IsLocation(LOCATION_HAND) then
			tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
			local e11=Effect.CreateEffect(c)
			e11:SetType(EFFECT_TYPE_SINGLE)
			e11:SetCode(EFFECT_PUBLIC)
			e11:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e11)
		end
	end
end
function cm.sumcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end