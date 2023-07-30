--千兆吞噬兽·烛火
function c11500100.initial_effect(c)
	--cost
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11500100,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE) 
	e1:SetOperation(c11500100.mtop)
	c:RegisterEffect(e1)
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA) 
	e1:SetCondition(c11500100.espcon)
	e1:SetOperation(c11500100.espop)
	c:RegisterEffect(e1) 
	--atk/def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(function(e,c)
	return Duel.GetMatchingGroupCount(Card.IsFacedown,0,LOCATION_REMOVED,LOCATION_REMOVED,nil)*200 end)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	c:RegisterEffect(e2)  
	--cannot release
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UNRELEASABLE_SUM)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e4:SetValue(function(e,c,sumtype)
	return sumtype==SUMMON_TYPE_FUSION end) 
	c:RegisterEffect(e4)
	local e5=e2:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e5)
	local e6=e2:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e6) 
	local e7=e2:Clone()
	e7:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL) 
	c:RegisterEffect(e7) 
	--remove 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_SEND_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c11500100.reptg)
	e2:SetValue(c11500100.repval)
	c:RegisterEffect(e2) 
	--
	local e3=Effect.CreateEffect(c) 
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BATTLE_START) 
	e3:SetRange(LOCATION_MZONE) 
	e3:SetCondition(c11500100.ovcon) 
	e3:SetOperation(c11500100.ovop) 
	c:RegisterEffect(e3) 
	--xov 
	local e4=Effect.CreateEffect(c) 
	e4:SetDescription(aux.Stringid(11500100,4))
	e4:SetType(EFFECT_TYPE_QUICK_O) 
	e4:SetCode(EVENT_FREE_CHAIN) 
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER) 
	e4:SetRange(LOCATION_MZONE) 
	e4:SetCountLimit(1) 
	e4:SetTarget(c11500100.xovtg) 
	e4:SetOperation(c11500100.xovop) 
	c:RegisterEffect(e4) 
end 
function c11500100.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.HintSelection(Group.FromCards(c)) 
	local x=c:GetOverlayCount()
	if x<=0 then return end 
	local g=Duel.GetDecktopGroup(tp,x) 
	if g:FilterCount(Card.IsAbleToRemoveAsCost,nil)==x then  
		Duel.Remove(g,POS_FACEDOWN,REASON_COST) 
	else 
		Duel.Remove(c,POS_FACEDOWN,REASON_COST)
	end
end
function c11500100.ovfil(c,tp) 
	local g=Duel.GetDecktopGroup(tp,c:GetLevel())
	return c:IsCanOverlay() and c:IsLevelAbove(1) and g:FilterCount(Card.IsAbleToRemove,nil)==c:GetLevel() 
end 
function c11500100.ovgck(g,e,tp) 
	return Duel.GetLocationCountFromEx(tp,tp,g,e:GetHandler())>0 and g:GetClassCount(Card.GetLevel)==g:GetCount()  
end 
function c11500100.espcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler() 
	local g=Duel.GetMatchingGroup(c11500100.ovfil,tp,LOCATION_MZONE,0,nil,tp)
	return g:CheckSubGroup(c11500100.ovgck,3,3,e,tp)  
end
function c11500100.espop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c11500100.ovfil,tp,LOCATION_MZONE,0,nil,tp)
	local og=g:SelectSubGroup(tp,c11500100.ovgck,false,3,3,e,tp) 
	local lv=og:GetFirst():GetLevel() 
	local rg=Duel.GetDecktopGroup(tp,lv)
	Duel.Remove(rg,POS_FACEDOWN,REASON_COST) 
	Duel.Overlay(c,og) 
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(11500100,1))
	Duel.Hint(HINT_MESSAGE,1,aux.Stringid(11500100,1))
end
function c11500100.repfilter(c,e,tp)
	return e:GetHandler():GetOverlayGroup():IsContains(c) and c:GetDestination()==LOCATION_GRAVE and c:IsAbleToRemove()
end
function c11500100.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c11500100.repfilter,1,nil,e,tp) end 
	local g=eg:Filter(c11500100.repfilter,nil,e,tp) 
	Duel.Remove(g,POS_FACEDOWN,REASON_REDIRECT) 
	return true 
end
function c11500100.repval(e,c)
	return false
end
function c11500100.ovcon(e,tp,eg,ep,ev,re,r,rp) 
	local bc=e:GetHandler():GetBattleTarget()
	return bc and bc:IsCanOverlay() 
end 
function c11500100.ovop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if c11500100.ovcon(e,tp,eg,ep,ev,re,r,rp)==false then return end 
	local bc=e:GetHandler():GetBattleTarget()
	Duel.Hint(HINT_CARD,0,11500100) 
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(11500100,2))
	Duel.Hint(HINT_MESSAGE,1,aux.Stringid(11500100,2))
	Duel.Overlay(c,bc) 
end 
function c11500100.xovtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(Card.IsCanOverlay,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,e:GetHandler()) 
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and g:GetCount()>0 end  
	local sg=e:GetHandler():GetOverlayGroup():Select(tp,1,99,nil) 
	local x=sg:GetCount() 
	Duel.SendtoGrave(sg,REASON_EFFECT)
	e:SetLabel(x)  
end 
function c11500100.xovop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local x=e:GetLabel() 
	local g=Duel.GetMatchingGroup(Card.IsCanOverlay,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,e:GetHandler())  
	if x and x>0 and g:GetCount()>0 and c:IsRelateToEffect(e) then  
		local og=g:Select(tp,1,x,nil)
		Duel.Overlay(c,og)  
		Duel.Hint(HINT_MESSAGE,0,aux.Stringid(11500100,3))
		Duel.Hint(HINT_MESSAGE,1,aux.Stringid(11500100,3))
	end 
	local ph=Duel.GetCurrentPhase()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SKIP_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	if Duel.GetTurnPlayer()==tp and ph>PHASE_MAIN1 and ph<PHASE_MAIN2 then
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetCondition(function (e)
		return Duel.GetTurnCount()~=e:GetLabel() end)
		e1:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_SELF_TURN,2)
	else
		e1:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_SELF_TURN,1)
	end
	Duel.RegisterEffect(e1,tp)
end 





