--てんそく
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c)	
	c:SetUniqueOnField(1,0,id,LOCATION_MZONE)
	--ritual summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CUSTOM+id)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--act limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(s.chainop)
	c:RegisterEffect(e2)
	--xtra spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.espcon)
	e3:SetTarget(s.esptg)
	e3:SetOperation(s.espop)
	c:RegisterEffect(e3)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetCondition(s.regcon)
		ge1:SetOperation(s.regop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_TO_DECK)
		ge2:SetCondition(s.regcon2)
		ge2:SetOperation(s.regop2)
		Duel.RegisterEffect(ge2,0)
	end
end
function s.cfilter1(c)
	return c:IsType(TYPE_PENDULUM)
end
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter1,1,nil)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseEvent(eg,EVENT_CUSTOM+id,re,r,rp,ep,ev)
end
function s.cfilter2(c)
	return c:IsType(TYPE_PENDULUM) and c:IsPosition(POS_FACEUP) and c:IsLocation(LOCATION_EXTRA)
end
function s.regcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter2,1,nil)
end
function s.regop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseEvent(eg,EVENT_CUSTOM+id,re,r,rp,ep,ev)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.thfilter(c)
	return c:IsRace(RACE_ZOMBIE) and c:IsAbleToHand()
		and c:IsType(TYPE_PENDULUM) and not c:IsCode(id)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,true,true,POS_FACEUP)~=0 then
		c:CompleteProcedure()
		if Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
	end
end
function s.chainop(e,tp,eg,ep,ev,re,r,rp)
	local cc=re:GetHandler()
	if (cc:IsLocation(LOCATION_PZONE) or (re:IsActiveType(TYPE_PENDULUM) and re:IsActiveType(TYPE_SPELL) and cc:IsLocation(LOCATION_SZONE))) and cc:GetControler()==tp then
		Duel.SetChainLimit(s.chainlm)
	end
end
function s.chainlm(re,rp,tp)
	return not re:IsActiveType(TYPE_MONSTER)
end
function s.espcfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_EXTRA) and ((c:IsType(TYPE_PENDULUM) and c:IsFaceup() and c:IsControler(tp)) or c:IsControler(1-tp)) 
end
function s.espcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.espcfilter,1,nil,tp)
end
function s.espfilter(c,e,tp,type)
	return c:IsRace(RACE_ZOMBIE) and c:IsType(type) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsFaceup() and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function s.afilter(c,e,tp)
	local type=(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ)&c:GetType()
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsRace(RACE_ZOMBIE) and type~=0 and Duel.IsExistingMatchingCard(s.espfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,type) and (Duel.IsExistingMatchingCard(s.bafilter,tp,LOCATION_MZONE,0,1,nil,e,type) or Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil,e))
end
function s.bafilter(c,e,type)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsType(type) and c:IsDestructable(e)
end
function s.esptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.afilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp) end
	local g=Duel.GetMatchingGroup(s.afilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e,tp)
	local tc=g:GetFirst()
	local type=0
	while tc do
		type=type|((TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ)&tc:GetType())
		tc=g:GetNext()
	end
	local types={}
	if type&TYPE_FUSION~=0 then table.insert(types,1056) end
	if type&TYPE_SYNCHRO~=0 then table.insert(types,1063) end
	if type&TYPE_XYZ~=0 then table.insert(types,1073) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	local rc=types[Duel.SelectOption(tp,table.unpack(types))+1]
	e:SetLabel(rc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end
function s.espop(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetLabel()
	local type=0
	if rc==1056 then type=TYPE_FUSION end
	if rc==1063 then type=TYPE_SYNCHRO end
	if rc==1073 then type=TYPE_XYZ end
	if Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_XYZ+TYPE_SYNCHRO+TYPE_FUSION)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.espfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,type)
		if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) then
			local b1g=Duel.GetMatchingGroup(s.bafilter,tp,LOCATION_MZONE,0,nil,e,type)
			local b2g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_ONFIELD,nil,e)
			local b1=b1g:GetCount()>0
			local b2=b2g:GetCount()>0
			if not (b1 or b2) then return end
			local op=aux.SelectFromOptions(1-tp,{b1,aux.Stringid(id,3)},{b2,aux.Stringid(id,4)})
			Duel.Hint(HINT_SELECTMSG,tp,HINT_OPSELECTED)
			if op==1 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local sg=b1g:Select(tp,1,1,nil)
				Duel.HintSelection(sg)
				Duel.Destroy(sg,REASON_EFFECT)
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local sg=b2g:Select(tp,1,1,nil)
				Duel.HintSelection(sg)
				Duel.Destroy(sg,REASON_EFFECT)
			end
		end
	end
end