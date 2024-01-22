--烙印闭幕
function c50204105.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(50204105,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,50204105)
	e1:SetCondition(c50204105.thcon)
	e1:SetTarget(c50204105.thtg)
	e1:SetOperation(c50204105.thop)
	c:RegisterEffect(e1)
	--pay and spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(50204105,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,50204106)
	e2:SetCondition(c50204105.spcon)
	e2:SetTarget(c50204105.sptg)
	e2:SetOperation(c50204105.spop)
	c:RegisterEffect(e2)
end
function c50204105.cfilter(c,tp)
	return c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_FUSION) and c:IsSummonPlayer(tp)
end
function c50204105.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c50204105.cfilter,1,nil,tp)
end
function c50204105.thfilter(c)
	return c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and c:IsFaceup() and c:IsAbleToHand()
end
function c50204105.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local fc=eg:GetFirst()
	local fg=Group.CreateGroup()
	while fc do
		local mg=fc:GetMaterial():Filter(c50204105.thfilter,nil)
		if mg:GetCount()>0 then
			fg:AddCard(fc)
		end
		fc=eg:GetNext()
	end
	if chk==0 then return fg:GetCount()~=0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c50204105.thop(e,tp,eg,ep,ev,re,r,rp)
	local fc=eg:GetFirst()
	local fg=Group.CreateGroup()
	while fc do
		local mg=fc:GetMaterial():Filter(c50204105.thfilter,nil)
		if mg:GetCount()>0 then
			fg:AddCard(fc)
		end
		fc=eg:GetNext()
	end
	local tc=fg:GetFirst()
	if fg:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		tc=fg:Select(tp,1,1,nil):GetFirst()
	end
	local mg=tc:GetMaterial():Filter(c50204105.thfilter,nil)
	local tg=mg:Select(tp,1,1,nil)
	if tg:GetCount()>0 then
		if Duel.SendtoHand(tg,nil,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,tg)
		end
	end
end
function c50204105.cfilter2(c,tp)
	return c:IsType(TYPE_FUSION) and c:GetReasonPlayer()==1-tp and c:IsPreviousControler(tp)
		and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP)
end
function c50204105.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c50204105.cfilter2,1,nil,tp)
end
function c50204105.filter0(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave()
end
function c50204105.filter1(c,mg)
	aux.FGoalCheckAdditional=c50204105.fcheck
	local res=c:CheckFusionMaterial(mg)
	aux.FGoalCheckAdditional=nil
	return res and c:IsAbleToExtra()
end
function c50204105.fcheck(tp,sg,fc)
	return sg:GetCount()<=2
end
function c50204105.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(c50204105.filter0,tp,LOCATION_DECK,0,nil)
	local sg=eg:Filter(c50204105.filter1,nil,mg)
	if chk==0 then return sg:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_GRAVE)
end
function c50204105.spop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg=Duel.GetMatchingGroup(c50204105.filter0,tp,LOCATION_DECK,0,nil)
	local sg=eg:Filter(c50204105.filter1,nil,mg)
	if sg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local tc=sg:Select(tp,1,1,nil):GetFirst()
		if sg:IsContains(tc) then
			if Duel.SendtoDeck(tc,tp,0,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_EXTRA) then
				Duel.BreakEffect()
				aux.FGoalCheckAdditional=c50204105.fcheck
				local matg=Duel.SelectFusionMaterial(tp,tc,mg,nil,chkf)
				aux.FGoalCheckAdditional=nil
				local mc=matg:GetFirst()
				local a=0
				while mc do 
					if Card.IsCanBeSpecialSummoned(mc,e,0,tp,false,false) and Duel.SelectYesNo(tp,aux.Stringid(50204105,a+2)) then
						Duel.SpecialSummon(mc,0,tp,tp,false,false,POS_FACEUP)
					else
						Duel.SendtoGrave(mc,tp,REASON_EFFECT)
					end
					mc=matg:GetNext()
					a=a+1
				end
			end
		end
	end
end