--五河琴里 毁灭之欲
local m=33401007
local cm=_G["c"..m]
function cm.initial_effect(c)
aux.AddFusionProcFunFunRep(c,cm.matfilter1,cm.matfilter,1,1,true)
c:EnableReviveLimit()
	 --indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.indcon)
	e1:SetOperation(cm.indop)
	c:RegisterEffect(e1)
 --destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.descon)
	e2:SetTarget(cm.destg)
	e2:SetOperation(cm.desop)
	c:RegisterEffect(e2)
--sps
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(m,2))
	e8:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e8:SetProperty(EFFECT_FLAG_DELAY)
	e8:SetCode(EVENT_DESTROYED)
	e8:SetCountLimit(1,m+10000)
	e8:SetTarget(cm.srtg)
	e8:SetOperation(cm.srop)
	c:RegisterEffect(e8)
end
function cm.matfilter1(c)
	return  c:IsSetCard(0x9341) and c:GetOriginalAttribute()==ATTRIBUTE_FIRE
end
function cm.matfilter(c)
	return c:IsSetCard(0x9341)
end

function cm.indcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetMaterial()
	local res=0
	local tc=g:GetFirst()
	while tc do
	   if  tc:IsType(TYPE_FUSION) and tc:IsType(TYPE_MONSTER) then res=1 end
		tc=g:GetNext()
	end
	return c:IsSummonType(SUMMON_TYPE_FUSION) and res==1
end
function cm.indop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	 --atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetValue(500)
	c:RegisterEffect(e3)
 --pierce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_PIERCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	c:RegisterEffect(e2)
end

function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,nil)
	local tc=g:GetFirst()
	local d1=0
	local d2=0
	while tc do
	   if tc:GetControler()==tp then d1=d1+1 else d2=d2+1 end 
	  tc=g:GetNext()
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	if d1>0 then Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,d1*500) end 
	if d2>0 then Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,d2*500) end
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()~=0 then 
	   local tc=g:GetFirst()
		 while tc do
			if Duel.Destroy(tc,REASON_EFFECT)~=0 then
			 Duel.Damage(tc:GetControler(),500,REASON_EFFECT) 
			end
			tc=g:GetNext()
		 end
	end  
end

function cm.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,500)
end
function cm.srop(e,tp,eg,ep,ev,re,r,rp)
   local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if  Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.Damage(tp,500,REASON_EFFECT)
			--must attack
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_MUST_ATTACK)
		c:RegisterEffect(e1)
		end	  
	end
end