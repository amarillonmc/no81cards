--烈焰·琉璃
local cm,m,o=GetID()
cm.name = "烈焰`琉璃"
function cm.initial_effect(c)
	--fusion material
	aux.AddCodeList(c,60002336,60002335)
	aux.AddFusionProcCode2(c,60002336,60002335,true,true)
	--attribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetRange(0xff)
	e1:SetValue(ATTRIBUTE_FIRE)
	c:RegisterEffect(e1)
	--fusion type
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EFFECT_ADD_TYPE)
	e1:SetRange(0xff)
	e1:SetValue(TYPE_FUSION)
	c:RegisterEffect(e1)
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e1)
	--Effect 2
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetTarget(cm.tg)
	e3:SetOperation(cm.op)
	c:RegisterEffect(e3)
	--grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60001173,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.hstg)
	e2:SetOperation(cm.hsop)
	c:RegisterEffect(e2)
end
cm.is_fusion=true
if not changefusion then
	changefusion=true
	cm.is_type=Card.IsType
	Card.IsType=function(car,typ,...)
		if typ&TYPE_FUSION>0 then
			return cm.is_type(car,typ,...) or car.is_fusion
		else
			return cm.is_type(car,typ,...)
		end
	end
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	if Duel.Destroy(sg,REASON_EFFECT)~=0 then
		local dmg=e:GetHandler():GetAttack()
		Duel.Damage(1-tp,dmg,REASON_EFFECT)
	end
end
function cm.afil2(c)
	return aux.IsCodeListed(c,60002336) and aux.IsCodeListed(c,60002335) and c:IsAbleToHand()
end
function cm.hstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.afil2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.hsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,cm.afil2,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
	end
end