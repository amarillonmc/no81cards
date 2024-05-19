--清炒蔬菜料理
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,11637005)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(s.splimit)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(s.checkop2)
		Duel.RegisterEffect(ge1,0)
	end
end

s.FoodMaterial_Listed={11637005}

function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	Duel.RegisterFlagEffect(0,id,RESET_CHAIN,0,1,tc:GetCode())
end
function s.checkop2(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:IsSetCard(0x9221) then
			Duel.RegisterFlagEffect(0,81,RESET_CHAIN,0,1)
		end
	end
end

function s.label_check(...)
	local labels={...}
	local flag=false
	if labels then 
		for i = 0, #labels do 
			if labels[i]==11637005 then flag=true end
		end
	end
	return flag
end
function s.splimit(e,se,sp,st)
	return s.label_check(Duel.GetFlagEffectLabel(0,id)) and se:GetHandler():IsSetCard(0xa221) and Duel.GetFlagEffect(0,81)==0
end

function s.thfilter(c,e,tp)
	local flag=false
	if c:IsType(TYPE_MONSTER) then
		flag=c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	elseif c:IsType(TYPE_SPELL+TYPE_TRAP) then
		flag=c:IsSSetable()
	end
	return c:IsSetCard(0x9221) and (c:IsAbleToHand() or flag) and c:IsFaceupEx()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_GRAVE+LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp):GetFirst()
	if not tc then return end
	local flag1=tc:IsAbleToHand()
	local flag2=false
	if tc:IsType(TYPE_MONSTER) then
		flag2=tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	elseif tc:IsType(TYPE_SPELL+TYPE_TRAP) then
		flag2=tc:IsSSetable()
	end
	local op=aux.SelectFromOptions(tp,{flag1,aux.Stringid(id,1)},{flag2,aux.Stringid(id,2)})
	if op==1 then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	elseif op==2 then
		if tc:IsType(TYPE_MONSTER) then 
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SSet(tp,tc)
		end
	end
end
