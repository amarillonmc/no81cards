--逢魔龙 终焉时王
function c25000037.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c25000037.spcon)
	e1:SetOperation(c25000037.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e2)	
	--xx
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c25000037.xxcon)
	e3:SetOperation(c25000037.xxop1)
	c:RegisterEffect(e3) 
	--xx
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c25000037.xxcon)
	e3:SetOperation(c25000037.xxop2)
	c:RegisterEffect(e3)	 
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e5=e3:Clone()
	e5:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e5)
end
c25000037.spchecks=aux.CreateChecks(Card.IsType,{TYPE_RITUAL+TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_PENDULUM+TYPE_LINK})
function c25000037.spcostfilter(c)
	return c:IsFaceup() and c:IsReleasable() and c:IsType(TYPE_RITUAL+TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_PENDULUM+TYPE_LINK) and c:IsRace(RACE_DRAGON)
end
function c25000037.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c25000037.spcostfilter,tp,LOCATION_MZONE,0,nil)
	return g:CheckSubGroupEach(c25000037.spchecks,aux.mzctcheck,tp)
end
function c25000037.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c25000037.spcostfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=g:SelectSubGroupEach(tp,c25000037.spchecks,false,aux.mzctcheck,tp)
	Duel.Release(sg,REASON_COST)
end
function c25000037.xxcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==1  
end
function c25000037.xxop1(e,tp,eg,ep,ev,re,r,rp) 
	if Duel.IsExistingMatchingCard(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(25000037,0)) then 
	Duel.Hint(HINT_CARD,0,25000037)
	Duel.ConfirmCards(1-tp,e:GetHandler())
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c25000037.repop) 
	end
end
function c25000037.repop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsControlerCanBeChanged,tp,LOCATION_MZONE,0,1,nil) 
	if g:GetCount()>0 then 
	local sg=g:Select(tp,1,1,nil) 
	Duel.GetControl(sg,1-tp)
	end
end
function c25000037.gck(g,tp)   
	return g:GetCount()==g:FilterCount(Card.IsControlerCanBeChanged,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>=g:GetCount() 
end
function c25000037.xxop2(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	if eg:CheckSubGroup(c25000037.gck,eg:GetCount(),eg:GetCount(),tp) and Duel.SelectYesNo(tp,aux.Stringid(25000037,0)) then 
	Duel.Hint(HINT_CARD,0,25000037)
	Duel.ConfirmCards(1-tp,e:GetHandler()) 
	Duel.GetControl(eg,tp) 
	end
end







