--魔导飞行队接引指令
local cm,m=GetID()
function cm.initial_effect(c)
	if not PNFL_PROPHECY_FLIGHT_CHECK then
		dofile("expansions/script/c11451851.lua")
		pnfl_prophecy_flight_initial(c)
	end
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,11))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(cm.pzcon)
	e3:SetCost(cm.pzcost)
	e3:SetTarget(cm.pztg)
	e3:SetOperation(cm.pzop)
	c:RegisterEffect(e3)
end
function cm.sfilter(c,e)
	return c:IsType(TYPE_SPELL) and (c:IsFaceup() or c:GetEquipTarget() or c:IsLocation(LOCATION_FZONE)) and c:IsOnField() and (not e or c:IsCanBeEffectTarget(e))
end
function cm.mfilter(c,e)
	return c:IsRace(RACE_SPELLCASTER) and c:IsFaceup() and not c:IsOnField() and (not e or c:IsCanBeEffectTarget(e))
end
function cm.fselect(g)
	local ct1=g:FilterCount(Card.IsOnField,nil)
	local ct2=g:FilterCount(cm.sfilter,nil)
	local ct3=g:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
	local ct4=g:FilterCount(cm.mfilter,nil)
	return ct1%2==0 and ct3%2==0 and ct1<=2*ct2 and ct3<=2*ct4
end
function cm.fselect2(g)
	local ct1=g:FilterCount(Card.IsOnField,nil)
	local ct3=g:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
	return ct1%2==0 and ct3%2==0
end
function cm.fselect3(g)
	local ct2=g:FilterCount(cm.sfilter,nil)
	return #g%2==0 and #g<=2*ct2
end
function cm.fselect4(g)
	return #g%2==0
end
function cm.fselect5(g)
	local ct4=g:FilterCount(cm.mfilter,nil)
	return #g<=2*ct4
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return false end
	if chk==0 then return (Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,c) and Duel.IsExistingTarget(cm.sfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c,e)) or (Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_GRAVE,LOCATION_GRAVE,2,nil) and Duel.IsExistingTarget(cm.mfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e)) end
	--local g=Duel.GetMatchingGroup(Card.IsCanBeEffectTarget,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,c,e)
	local g1=Duel.GetMatchingGroup(Card.IsCanBeEffectTarget,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c,e)
	local g2=Duel.GetMatchingGroup(Card.IsCanBeEffectTarget,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e)
	local g3=Duel.GetMatchingGroup(cm.mfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	--aux.GCheckAdditional=cm.fselect
	local tg=g1:SelectSubGroup(tp,cm.fselect3,false,0,#g1)
	aux.GCheckAdditional=cm.fselect5
	local tg2=g2:SelectSubGroup(tp,cm.fselect4,false,math.max(0,2-#g1),#g2)
	aux.GCheckAdditional=nil
	tg:Merge(tg2)
	Duel.SetTargetCard(tg)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	for tc in aux.Next(sg) do
		local fid=c:GetFieldID()
		local ge2=Effect.CreateEffect(c)
		ge2:SetDescription(aux.Stringid(m,10))
		ge2:SetType(EFFECT_TYPE_SINGLE)
		ge2:SetCode(EFFECT_IMMUNE_EFFECT)
		ge2:SetRange(LOCATION_ONFIELD+LOCATION_GRAVE)
		ge2:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_SET_AVAILABLE)
		ge2:SetLabel(fid)
		ge2:SetValue(cm.chkval)
		ge2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		tc:RegisterEffect(ge2,true)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e5:SetCode(EVENT_ADJUST)
		e5:SetLabel(fid)
		e5:SetCondition(function() return not pnfl_adjusting end)
		e5:SetOperation(cm.acop)
		Duel.RegisterEffect(e5,tp)
	end
end
function cm.chkval(e,te)
	if te and te:GetHandler() and not te:IsHasProperty(EFFECT_FLAG_UNCOPYABLE) then
		e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET,0,1,e:GetLabel())
		--Duel.AdjustAll()
		--Duel.Readjust()
		e:SetValue(aux.FALSE)
		e:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		return true
	end
	return false
end
function cm.filter1(c,fid)
	return c:GetFlagEffect(m)>0 and c:GetFlagEffectLabel(m)==fid
end
function cm.acop(e,tp,eg,ep,ev,re,r,rp)
	if pnfl_adjusting then return end
	pnfl_adjusting=true
	local g=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,nil,e:GetLabel())
	g:ForEach(Card.ResetFlagEffect,m)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	pnfl_adjusting=false
end
function cm.coincon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetCode()~=EVENT_TOSS_COIN_NEGATE
end
function cm.coinop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(m)==0 and Duel.SelectEffectYesNo(tp,c) then
		Duel.ConfirmCards(1-tp,c)
		Duel.Hint(HINT_CARD,0,m)	
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
		local res={Duel.GetCoinResult()}
		local ac=1
		local ct=ev
		if ct>1 then
			--choose the index of results
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,11))
			local val,idx=Duel.AnnounceNumber(tp,table.unpack(aux.idx_table,1,ct))
			ac=idx+1
		end
		res[ac]=1
		Duel.SetCoinResult(table.unpack(res))
		--[[local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		cm[c]=e1--]]
		Duel.RaiseSingleEvent(c,EVENT_CUSTOM+m,e,0,0,0,0)
	end
end
function cm.pzcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonPlayer,1,nil,tp)
end
function cm.pzcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=eg:Filter(Card.IsSummonPlayer,nil,tp)
	if chk==0 then return #g==g:FilterCount(Card.IsAbleToHandAsCost,nil) end
	Duel.SendtoHand(g,nil,REASON_COST)
end
function cm.filter(c,e,tp,b1,b2)
	return c:IsSetCard(0x6e) and (((b1 and ((c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) or c:IsSSetable()))) or (b2 and c:IsAbleToDeck()))
end
function cm.pztg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1,b2=c:IsAbleToDeck(),c:IsSSetable()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE,0,1,c,e,tp,b1,b2) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
end
function cm.pzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local b1,b2=c:IsAbleToDeck(),c:IsSSetable()
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_GRAVE,0,c,e,tp,b1,b2)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		local s1=b1 and ((tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) or tc:IsSSetable())
		local s2=b2 and tc:IsAbleToDeck()
		local sg=Group.FromCards(c,tc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		if s1 and (not s2 or sg:Select(tp,1,1,nil):IsContains(tc)) then
			if tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and (not tc:IsSSetable() or Duel.SelectYesNo(tp,Stringid(m,12))) then
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
				Duel.ConfirmCards(1-tp,tc)
			else
				Duel.SSet(tp,tc)
			end
			Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
		else
			Duel.SSet(tp,c)
			Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
		end
	end
end