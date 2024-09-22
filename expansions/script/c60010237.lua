--光天道 圣赫克鲁斯
local cm,m,o=GetID()
function cm.initial_effect(c)
	-- spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_DECK)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.spop)
	e1:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(e1)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(0,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.thcon)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
end
if not cm.gtd then cm.gtd={} end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(Card.IsLevel,tp,LOCATION_HAND,0,nil,12)
	return g:GetClassCount(Card.GetCode)>=3
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(Card.IsLevel,tp,LOCATION_HAND,0,nil,12)
	local cg=Group.CreateGroup()
	for i=1,3 do
		local sg=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,sg:GetFirst():GetCode())
		cg:Merge(sg)
	end
	Duel.ConfirmCards(1-tp,cg)
end

function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return cm.gtd[atk]~=1
end
function cm.thfilter(c,atk)
	return c:IsAttack(atk) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local atk=e:GetHandler():GetAttack()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil,atk) and cm.gtd[atk]~=1 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local atk=e:GetHandler():GetAttack()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,atk)
	if g:GetCount()>0 and cm.gtd[atk]~=1 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		cm.gtd[atk]=1
	end
end