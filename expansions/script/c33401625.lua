--天使-雷霆圣堂
local m=33401625
local cm=_G["c"..m]
function cm.initial_effect(c)
	 c:SetUniqueOnField(1,0,m)
	  --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
 --atk up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.con)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
--tg
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,2))
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_PHASE+PHASE_END)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCountLimit(1,m)
	e6:SetTarget(cm.tgtg)
	e6:SetOperation(cm.tgop)
	c:RegisterEffect(e6)
end
function cm.ckfilter2(c,at)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)   and  c:IsAttribute(at)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(cm.ckfilter2,tp,LOCATION_MZONE,0,1,nil,rc:GetAttribute())
end
function cm.ckfilter3(c,at)
	return c:IsSetCard(0x6344) and c:IsFaceup() and c:IsType(TYPE_MONSTER)   and   c:IsAttribute(at)
end
function cm.spfilter1(c,e,tp)
	return  c:IsSetCard(0x6344) and c:IsType(TYPE_MONSTER) and not Duel.IsExistingMatchingCard(cm.ckfilter3,tp,LOCATION_MZONE,0,1,nil,c:GetAttribute()) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.atfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6344) and c:IsType(TYPE_MONSTER) and c:GetAttribute()~=0
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()
	 if chk==0 then 
		local g=Duel.GetMatchingGroup(cm.atfilter,c:GetControler(),LOCATION_MZONE,0,nil)
		local att=0
		local tc=g:GetFirst()
		while tc do
			att=bit.bor(att,tc:GetAttribute())
			tc=g:GetNext()
		end
		local ct=0
		while att~=0 do
			if bit.band(att,0x1)~=0 then ct=ct+1 end
			att=bit.rshift(att,1)
		end
		return (Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp))or ct>=5 
	 end
		local g=Duel.GetMatchingGroup(cm.atfilter,c:GetControler(),LOCATION_MZONE,0,nil)
		local att=0
		local tc=g:GetFirst()
		while tc do
			att=bit.bor(att,tc:GetAttribute())
			tc=g:GetNext()
		end
		local ct=0
		while att~=0 do
			if bit.band(att,0x1)~=0 then ct=ct+1 end
			att=bit.rshift(att,1)
		end
	if ct<5 then
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	else
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
	end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
		local g=Duel.GetMatchingGroup(cm.atfilter,c:GetControler(),LOCATION_MZONE,0,nil)
		local att=0
		local tc=g:GetFirst()
		while tc do
			att=bit.bor(att,tc:GetAttribute())
			tc=g:GetNext()
		end
		local ct=0
		while att~=0 do
			if bit.band(att,0x1)~=0 then ct=ct+1 end
			att=bit.rshift(att,1)
		end
	 if not ((Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp))or ct>=5) then return end
	if ct<5 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.spfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	else
		local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end

function cm.ckfilter4(c)
	return c:IsSetCard(0x6344) and c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:GetFlagEffect(c:GetCode())==0  
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chk==0 then return Duel.IsExistingMatchingCard(cm.ckfilter4,tp,LOCATION_MZONE,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,0,1,0,0)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
if not Duel.IsExistingMatchingCard(cm.ckfilter4,tp,LOCATION_MZONE,0,1,nil) then return end
	local sc1=Duel.GetMatchingGroupCount(cm.ckfilter4,tp,LOCATION_MZONE,0,nil)
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tg=Duel.SelectMatchingCard(tp,cm.ckfilter4,tp,LOCATION_MZONE,0,1,sc1,nil)
	 local sc=tg:GetFirst()
		while sc do  
		 sc:RegisterFlagEffect(sc:GetCode(),RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,nil,0,aux.Stringid(33401601,0))
		sc=tg:GetNext()
		end
	local tg2=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,tg:GetCount(),nil)
	Duel.Destroy(tg2,REASON_EFFECT)   
end
