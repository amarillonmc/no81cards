--五河琴里 心之倒影
local m=33401005
local cm=_G["c"..m]
function cm.initial_effect(c)
   --
   local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
--sps
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCountLimit(1,m+10000)
	e3:SetTarget(cm.srtg)
	e3:SetOperation(cm.srop)
	c:RegisterEffect(e3)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return true end
	 Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function cm.ckfilter1(c)
	return   c:IsSetCard(0x9341) and c:IsFaceup()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g2=Duel.GetMatchingGroup(cm.ckfilter1,tp,LOCATION_ONFIELD,0,nil)
			local tc=g2:GetFirst()
			while tc do
				local e4=Effect.CreateEffect(e:GetHandler())
				e4:SetType(EFFECT_TYPE_SINGLE)
				e4:SetCode(EFFECT_IMMUNE_EFFECT)
				e4:SetValue(cm.efilter)
				e4:SetReset(RESET_EVENT+0x1fe0000+RESET_CHAIN)
				e4:SetOwnerPlayer(tp)
				tc:RegisterEffect(e4)
				tc=g2:GetNext()
			end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(1)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	if c:IsRelateToEffect(e) then
		Duel.Destroy(c,REASON_EFFECT)
	end
end

function cm.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) 
and e:GetHandler():IsLocation(LOCATION_GRAVE)  end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,500)
end
function cm.srop(e,tp,eg,ep,ev,re,r,rp)
   local c=e:GetHandler()
	if c:IsRelateToEffect(e) and e:GetHandler():IsLocation(LOCATION_GRAVE)  then
		 if  Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.Damage(tp,500,REASON_EFFECT)
		end
	end
end