--血源猎手 碎裂的大洋涡流
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
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local hg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_HAND,0,nil):Select(tp,x,x,nil)
	Duel.SendtoDeck(hg,tp,0,REASON_EFFECT)
	
	local hg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_HAND,0,nil)
	local fst=false
	local scd=false
	local trd=false
	
	if #Group.Filter(hg,Card.IsType,nil,TYPE_MONSTER)==1 and #Group.Filter(hg,Card.IsType,nil,TYPE_SPELL)==1 and #Group.Filter(hg,Card.IsType,nil,TYPE_TRAP)==1 then fst=true end
	if not hg:IsExists(Card.IsType,1,nil,TYPE_SPELL+TYPE_TRAP) then scd=true end
	if not hg:IsExists(Card.IsType,1,nil,TYPE_MONSTER) then trd=true end
	
	if fst==true then   
		local dg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_DECK,0,nil):Select(tp,x,x,nil)
		local tc=dg:GetFirst()
		while tc do
			Duel.MoveSequence(tc,SEQ_DECKTOP)
			tc=dg:GetNext()
		end
		Duel.SortDecktop(tp,tp,x)
	end

	if scd==true then
		Duel.ConfirmDecktop(tp,x)
		local hhg=Duel.GetDecktopGroup(tp,x)
		local yy=hhg:Filter(Card.IsType,nil,TYPE_MONSTER):GetCount()
		Duel.RegisterFlagEffect(e:GetHandler(),m,RESET_PHASE+PHASE_END,0,yy)
		--negate
		local e3=Effect.CreateEffect(c)
		e3:SetCategory(CATEGORY_DISABLE)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_CHAINING)
		e3:SetOperation(cm.negop1)
		e3:SetReset(RESET_PHASE+PHASE_END,1)
		Duel.RegisterEffect(e3,tp) 
	end
	if trd==true then
		Duel.ConfirmDecktop(tp,x)
		local hhg=Duel.GetDecktopGroup(tp,x)
		local yy=hhg:Filter(Card.IsType,nil,TYPE_SPELL):GetCount()+hhg:Filter(Card.IsType,nil,TYPE_TRAP):GetCount()
		Duel.RegisterFlagEffect(e:GetHandler(),m+20000000,RESET_PHASE+PHASE_END,0,yy)
		--negate
		local e3=Effect.CreateEffect(c)
		e3:SetCategory(CATEGORY_DISABLE)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_CHAINING)
		e3:SetOperation(cm.negop2)
		e3:SetReset(RESET_PHASE+PHASE_END,1)
		Duel.RegisterEffect(e3,tp) 
	end
	if c:IsRelateToEffect(e) and c:IsLocation(LOCATION_REMOVED) then
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	end
end
function cm.negop1(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc:GetControler()~=tp and rc:IsType(TYPE_MONSTER) and Duel.SelectEffectYesNo(tp,e:GetHandler()) then
		Duel.NegateEffect(ev)
		Duel.RegisterFlagEffect(e:GetHandler(),m+10000000,RESET_PHASE+PHASE_END,0,1)
		if Duel.GetFlagEffect(e:GetHandler(),m)==Duel.GetFlagEffect(e:GetHandler(),m+10000000) then
			e:Reset()
		end
	end
end
function cm.negop2(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc:GetControler()~=tp and (rc:IsType(TYPE_SPELL) or rc:IsType(TYPE_TRAP)) and Duel.SelectEffectYesNo(tp,e:GetHandler()) then
		Duel.NegateEffect(ev)
		Duel.RegisterFlagEffect(e:GetHandler(),m+30000000,RESET_PHASE+PHASE_END,0,1)
		if Duel.GetFlagEffect(e:GetHandler(),m+20000000)==Duel.GetFlagEffect(e:GetHandler(),m+30000000) then
			e:Reset()
		end
	end
end