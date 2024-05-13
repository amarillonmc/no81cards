--砂金-囚石铸金-
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,60010029)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.discon)
	e2:SetTarget(cm.distg)
	e2:SetOperation(cm.disop)
	c:RegisterEffect(e2)
end
cm.toss_dice=true
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp) end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local d1,d2,d3=Duel.TossDice(tp,3)
	Debug.Message(d1)
	Debug.Message(d2)
	Debug.Message(d3)
	local i=0
	if d1==6 then
		i=i+1
	end
	if d2==6 then
		i=i+1
	end
	if d3==6 then
		i=i+1
	end
	if i~=0 then
		Duel.Draw(tp,i*2,REASON_EFFECT)
		if i==3 then
			Duel.SelectOption(tp,aux.Stringid(m,0))
			Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(m,0))
			Duel.SelectOption(tp,aux.Stringid(m,1))
			Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(m,1))
			Duel.SelectOption(tp,aux.Stringid(m,2))
			Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(m,2))
			Duel.SelectOption(tp,aux.Stringid(m,3))
			Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(m,3))
			Duel.SelectOption(tp,aux.Stringid(m,4))
			Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(m,4))
			Duel.SelectOption(tp,aux.Stringid(m,5))
			Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(m,5))
			Duel.Hint(HINT_CARD,0,m+1)
			e:GetHandler():SetCardData(CARDDATA_CODE,m+1) 
			
			local e1=Effect.CreateEffect(c)
			e1:SetCategory(CATEGORY_TODECK+CATEGORY_COIN)
			e1:SetType(EFFECT_TYPE_IGNITION)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCountLimit(1)
			e1:SetTarget(cm.destg)
			e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
			e1:SetOperation(cm.desop)
			c:RegisterEffect(e1)
		end
	end
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,3)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c1,c2,c3=Duel.TossCoin(tp,3)
	if c1+c2+c3==3 then
		local bg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_HAND,nil)
		Duel.SendtoDeck(bg,nil,2,REASON_EFFECT)
	else
		local bg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_HAND,0,nil)
		if #bg~=0 then
			if #bg==1 then
				Duel.SendtoDeck(bg,nil,2,REASON_EFFECT)
			else
				Duel.SendtoDeck(bg:Select(tp,2,2,nil),nil,2,REASON_EFFECT)
			end
		end
	end
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and Duel.IsChainNegatable(ev) and Duel.GetTurnPlayer()==1-tp
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) and Duel.IsExistingMatchingCard(cm.ffil,tp,LOCATION_FZONE,0,1,nil) then
			Duel.Recover(tp,3000,REASON_EFFECT)
		end
	end
end

function cm.ffil(c)
	return c:IsCode(60010029) and c:IsFaceup()
end