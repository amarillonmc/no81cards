--动物朋友 荷兰乳牛
local m=33711401
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.spop)
	e1:SetValue(1)
	c:RegisterEffect(e1) 
	--Recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(cm.rcost)
	e2:SetTarget(cm.rtg)
	e2:SetOperation(cm.rop)
	c:RegisterEffect(e2)
	--send to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_RECOVER+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetTarget(cm.ttg)
	e3:SetOperation(cm.top)
	c:RegisterEffect(e3) 
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	return not Duel.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,0,1,nil) and mg:GetClassCount(Card.GetCode)==#mg
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.ConfirmCards(1-tp,e:GetHandler())
end
function cm.rcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.rfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x442) and c:IsDefenseAbove(0)
end
function cm.rtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and cm.rfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.rfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tg=Duel.SelectTarget(tp,cm.rfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,tg:GetFirst():GetDefense(),nil,tp,0)
end
function cm.rop(e,tp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Recover(tp,tc:GetDefense(),REASON_EFFECT)
	end
end
function cm.ttg(e,tp,eg,ep,ev,re,r,rp,chk)

	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>2 end
	--Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,1,nil,tp,LOCATION_DECK)
end
function cm.rfilter2(c)
	return c:IsSetCard(0x442) and c:IsAttackAbove(0)
end
function cm.top(e,tp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 then return end
	--local ac=0
	--Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,5))
	--if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>2 then
	 --   ac=Duel.AnnounceNumber(tp,1,2,3)
	--elseif Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>1 then
	 --   ac=Duel.AnnounceNumber(tp,1,2)
	--elseif Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 then
		--ac=Duel.AnnounceNumber(tp,1)
	--end
	local sg=Duel.GetDecktopGroup(tp,3)
	Duel.ConfirmDecktop(tp,3)
	--local sg=tg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	Duel.BreakEffect()
	if sg:GetClassCount(Card.GetCode)==#sg and sg:IsExists(cm.rfilter2,1,nil) then
		local rg=sg:Filter(cm.rfilter2,nil) 
		Duel.Recover(tp,rg:GetSum(Card.GetAttack),REASON_EFFECT)
	elseif sg:GetClassCount(Card.GetCode)<#sg then
		Duel.Damage(tp,2000,REASON_EFFECT)
	end
	if sg:GetCount()>0 then
		if Duel.SelectOption(tp,aux.Stringid(m,3),aux.Stringid(m,4))==0 then
			Duel.SendtoDeck(sg,nil,SEQ_DECKTOP,REASON_EFFECT)
		else
			Duel.SendtoDeck(sg,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
		end
	end
end