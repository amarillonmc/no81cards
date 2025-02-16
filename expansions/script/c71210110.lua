--邪奏咏破
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	s.set(c)
	s.lp(c)
end


function s.lp(c)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,id+1)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCondition(s.reccon)
	e2:SetTarget(s.rectg)
	e2:SetOperation(s.recop)
	c:RegisterEffect(e2)
end
function s.cfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_FUSION) and c:IsControler(tp)
end
function s.reccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(s.cfilter,nil,tp)
	local atk=g:GetSum(Card.GetBaseAttack,nil)
	if chk==0 then return atk>0 end
	e:SetLabel(atk)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,atk)
end
function s.recop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,e:GetLabel(),REASON_EFFECT)
end




local setzone=LOCATION_DECK+LOCATION_REMOVED+LOCATION_GRAVE+LOCATION_HAND
function s.set(c)
	--to hand
	local e5=Effect.CreateEffect(c)
	--e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1,id)
	e5:SetTarget(s.settg)
	e5:SetOperation(s.setop)
	c:RegisterEffect(e5)
end
function s.setfilter(c)
	return c:IsSetCard(0x897) and bit.band(c:GetType(),0x20004)==0x20004 and c:IsSSetable() and c:IsFaceupEx()
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local g=Duel.GetMatchingGroup(s.setfilter,tp,setzone,0,nil)
		return Duel.GetLocationCount(tp,LOCATION_SZONE)>4 and g:GetClassCount(Card.GetCode)>4 end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=4 then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.setfilter),tp,setzone,0,nil)
	if g:GetClassCount(Card.GetCode)<4 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,5,5)
	for i=1,5 do
		local scode=71210110+i*3
		local zode=2^(i-1) if i==0 then zode=1 end
		local tc=sg:Filter(Card.IsCode,nil,scode):GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true,zode)
	end
	--for tc in aux.Next(sg) do
	--	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	--end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.splimit(e,c)
	return not (c:IsSetCard(0x897) or c:IsLocation(LOCATION_EXTRA))
end