--无限姬 无限
local m=33700313
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,cm.lfilter,3)
	c:EnableReviveLimit()   
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(cm.limit)
	c:RegisterEffect(e1)  
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(cm.efilter)
	c:RegisterEffect(e2) 
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e4)
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(cm.condition)
	e5:SetTarget(cm.target)
	e5:SetOperation(cm.operation)
	c:RegisterEffect(e5)
	--atk
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	e6:SetValue(cm.atkval)
	c:RegisterEffect(e6)
end
function cm.atkfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x1449) or c:IsSetCard(0x3449))
end
function cm.atkval(e,c)
	local g=Duel.GetMatchingGroup(cm.atkfilter,c:GetControler(),LOCATION_MZONE,0,nil)
	return g:GetSum(Card.GetAttack)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and e:GetHandler():IsLocation(LOCATION_MZONE)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,0,0,tp,LOCATION_GRAVE)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,c)
	local zone={}
	zone[0]=c:GetLinkedZone(0)
	zone[1]=c:GetLinkedZone(1)
	if Duel.Destroy(sg,REASON_EFFECT)==0 and c:IsRelateToEffect(e) and c:IsLocation(LOCATION_MZONE) and zone[0]+zone[1]~=0 then return end
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_GRAVE,0,nil,e,tp,zone)
	local rg=Group.CreateGroup()
	if g:GetCount()<=0 or not Duel.SelectYesNo(tp,aux.Stringid(m,2)) then return end
	for i=1,g:GetCount() do
		zone[0]=c:GetLinkedZone(0)
		zone[1]=c:GetLinkedZone(1)
		g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_GRAVE,0,rg,e,tp,zone)
		if zone[0]+zone[1]<=0 or g:GetCount()<=0 or (i>1 and not Duel.SelectYesNo(tp,aux.Stringid(m,1))) then break end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		rg:AddCard(tc)
		local tp1=(zone[tp]>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone[tp]))
		local tp2=(zone[1-tp]>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp,zone[1-tp]))
		if tp1 and (not tp2 or not Duel.SelectYesNo(tp,aux.Stringid(m,3))) then
		  Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP,zone[tp])
		else
		  Duel.SpecialSummonStep(tc,0,tp,1-tp,false,false,POS_FACEUP,zone[1-tp])
		end
	end
	Duel.SpecialSummonComplete()
end
function cm.filter(c,e,tp,zone)
	return c:IsSetCard(0x1449) and ((c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone[tp]) and zone[tp]>0) or (c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp,zone[1-tp]) and zone[1-tp]>0))
end
function cm.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function cm.limit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
function cm.lfilter(c)
	return c:IsLinkSetCard(0x1449) or c:IsLinkSetCard(0x3449)
end

