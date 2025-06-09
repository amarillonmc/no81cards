--白坂小梅的降灵仪式
local s,id,o=GetID()
function s.initial_effect(c)
	
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.prop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.con2)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
end

function s.filter(c)
	return c:IsSetCard(0x60a)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=4 end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,1,0,LOCATION_DECK)
end
function s.prop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<4 then return end
	Duel.ConfirmDecktop(tp,4)
	local g=Duel.GetDecktopGroup(tp,4)
	local count = g:FilterCount(s.filter,nil)
	if g:GetCount()>0 and count>0 and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_DECK,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		local g2=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,6,6,nil)
		if g2:GetCount()>=6 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
			Duel.ConfirmCards(1-tp,g2)
			if Duel.ShuffleDeck(tp)~=0 then
				for i=1,10 do
					local tc
					if i<10 then
						tc=g2:RandomSelect(tp,1):GetFirst()
					else
						tc=g2:GetFirst()
					end
					Duel.MoveSequence(tc,SEQ_DECKTOP)
					g:RemoveCard(tc)
				end
			end
			Duel.Draw(tp,count,REASON_EFFECT)
		end
	end
	Duel.ShuffleDeck(tp)
end

function s.cfilter(c,tp,rp)
	return c:IsControler(tp) and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x60a)
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp,rp) and not eg:IsContains(e:GetHandler())
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SSet(tp,c)
	end
end