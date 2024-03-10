--血源猎手 永世的沉沦鲸梦
local cm,m,o=GetID()
function cm.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_ADJUST)
	e1:SetCondition(cm.rcon)
	e1:SetOperation(cm.rop)
	c:RegisterEffect(e1)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCountLimit(1,m)
	e3:SetTarget(cm.otg)
	e3:SetOperation(cm.oop)
	c:RegisterEffect(e3)
end
cm.toss_dice=true
function cm.rcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_HAND) and e:GetHandler():IsAbleToRemove()
end
function cm.rop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.Remove(c,POS_FACEUP,REASON_EFFECT)~=0 and Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_HAND,0)<=1 then
		Duel.Draw(e:GetHandlerPlayer(),1,REASON_EFFECT)
	end
end
function cm.otg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_DECK,0)>0 end
end
function cm.oop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local x=Duel.TossDice(tp,1)
	Duel.Draw(tp,x,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local hg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_HAND,0,nil):Select(tp,x,x,nil)
	Duel.SendtoDeck(hg,tp,0,REASON_EFFECT)
	local hg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_HAND,0,nil)
	local fst=false
	local scd=false
	local trd=false
	
	if hg:IsExists(Card.IsType,2,nil,TYPE_SPELL) then fst=true end
	if hg:IsExists(Card.IsType,2,nil,TYPE_MONSTER) then scd=true end
	if hg:IsExists(Card.IsType,1,nil,TYPE_MONSTER) and hg:IsExists(Card.IsType,1,nil,TYPE_SPELL) and hg:IsExists(Card.IsType,1,nil,TYPE_TRAP) then trd=true end
	
	if fst==true then   
		Duel.ConfirmDecktop(tp,x)
		local g=Duel.GetDecktopGroup(tp,x)
		if g:GetCount()>0 then
			local gc=g:GetFirst()
			for i=1,g:GetCount() do
				if gc:IsType(TYPE_SPELL) and gc:CheckActivateEffect(false,false,false)~=nil then
					local te=gc:GetActivateEffect()
					if gc:IsType(TYPE_FIELD) then
						Duel.MoveToField(gc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
						Duel.RaiseEvent(gc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
					else
						Duel.MoveToField(gc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
					end 
					te:UseCountLimit(tp,1,true)
					cm.ActivateCard(gc,tp,e)
					if not (gc:IsType(TYPE_CONTINUOUS) or gc:IsType(TYPE_FIELD) or gc:IsType(TYPE_EQUIP)) then
						Duel.SendtoGrave(gc,REASON_RULE)
					end
				end
				gc=g:GetNext()
			end
		end
	end

	if scd==true then
		Duel.ConfirmDecktop(tp,x)
		local g=Duel.GetDecktopGroup(tp,x)
		if g:GetCount()>0 then
			local gc=g:GetFirst()
			for i=1,g:GetCount() do
				if gc:IsType(TYPE_MONSTER) and gc:IsCanBeSpecialSummoned(e,0,tp,false,false) then
					Duel.SpecialSummon(gc,0,tp,tp,false,false,POS_FACEUP)
				end
				gc=g:GetNext()
			end
		end
	end
	if trd==true then
		Duel.ConfirmDecktop(tp,x)
		local hhg=Duel.GetDecktopGroup(tp,x)
		local mth=math.min(hhg:Filter(Card.IsType,nil,TYPE_MONSTER):GetCount(),hhg:Filter(Card.IsType,nil,TYPE_SPELL):GetCount(),hhg:Filter(Card.IsType,nil,TYPE_TRAP):GetCount())
		local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		if g:GetCount()>0 then
			Duel.ConfirmCards(1-tp,g)
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_DISCARD)
			local sg=g:Select(tp,1,mth,nil)
			Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
			Duel.ShuffleHand(1-tp)
		end
	end
end
function cm.ActivateCard(c,tp,oe)
	local e=c:GetActivateEffect()
	local cos,tg,op=e:GetCost(),e:GetTarget(),e:GetOperation()
	if e and (not cos or cos(e,tp,eg,ep,ev,re,r,rp,0)) and (not tg or tg(e,tp,eg,ep,ev,re,r,rp,0)) then
		oe:SetProperty(e:GetProperty())
		local code=c:GetOriginalCode()
		Duel.Hint(HINT_CARD,tp,code)
		Duel.Hint(HINT_CARD,1-tp,code)
		e:UseCountLimit(tp,1,true)
		c:CreateEffectRelation(e)
		if cos then cos(e,p,eg,ep,ev,re,r,rp,1) end
		if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		if g and #g~=0 then
			local tg=g:GetFirst()
			while tg do
				tg:CreateEffectRelation(e)
				tg=g:GetNext()
			end
		end
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
		c:ReleaseEffectRelation(e)
		if g then
			tg=g:GetFirst()
			while tg do
				tg:ReleaseEffectRelation(e)
				tg=g:GetNext()
			end
		end
	end
end















