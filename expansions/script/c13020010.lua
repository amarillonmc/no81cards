--所谓伊人
local cm, m, ofs = GetID()
local yr = 13020010
xpcall(function() dofile("expansions/script/c16670000.lua") end,function() dofile("script/c16670000.lua") end)--引用库
function cm.initial_effect(c)
	aux.AddCodeList(c, yr)
local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_EQUIP)
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetRange(LOCATION_HAND)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetCost(cm.cost)
	e0:SetCondition(cm.setcon)
	e0:SetTarget(cm.target)
	e0:SetOperation(cm.operation)
	c:RegisterEffect(e0)
	local e3=xg.epp2(c,m,4,EVENT_EQUIP,nil,QY_md+QY_cw,cm.setcon3,nil,nil,cm.operation2,true)
	e3:SetCountLimit(1,m+EFFECT_COUNT_CODE_CHAIN)
	if cm.gl==nil then
		cm.gl=true
		cm[0]=0
		cm[1]=0
	end
end

function cm.ffilter(c,c2)
	return c:CheckEquipTarget(c2)
end
function cm.filter(c,e,g)
	local g2=g:Filter(cm.ffilter, nil,c)
	return c:IsCanBeEffectTarget(e) and g2 and #g2>0
end
function cm.filter2(c)
	return c:IsType(TYPE_EQUIP) and not c:IsForbidden() and aux.IsCodeListed(c, yr)
end
function cm.filter3(c,g)
	return g:IsContains(c)
end
function cm.setcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_HAND,0,nil)
	local g2=Duel.GetMatchingGroup(cm.filter,tp,QY_gs,QY_gs,nil,e,g)
	-- local g3=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,nil)
	-- local g4=Duel.GetMatchingGroup(cm.filter,tp,QY_gs,QY_gs,nil,e,g3)
	return g2 and #g2>0 or (Duel.GetTurnPlayer()==e:GetHandlerPlayer() and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil))
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_DISCARD)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local oc=LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK
	if Duel.GetTurnPlayer()~=e:GetHandlerPlayer() then
		oc=QY_sk
	end
	local g=Duel.GetMatchingGroup(cm.filter2,tp,oc,0,nil)
	local g2=Duel.GetMatchingGroup(cm.filter,tp,QY_gs,QY_gs,nil,e,g)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and g:IsContains(chkc) end
	if chk==0 then return g2 and #g2>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	Duel.SelectTarget(tp,cm.filter3,tp,QY_gs,QY_gs,1,1,nil,g2)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsCanBeDisabledByEffect(e) then
		local oc=LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK
		if Duel.GetTurnPlayer()~=e:GetHandlerPlayer() then
			oc=QY_sk
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local tcg=Duel.SelectMatchingCard(tp,cm.filter2,tp,oc,0,1,1,nil):GetFirst()
		Duel.Equip(tp,tcg,tc,true)
	end
end
function cm.filter5(c,e,tp)
	return c:IsAbleToDeck()
end
function cm.filter6(c,e,tp)
	return c:IsType(TYPE_EQUIP) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function cm.setcon3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp, m)<=0
end
function cm.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsType(TYPE_NORMAL)
end
function cm.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	cm[tp]=cm[tp]+1
	local num=cm[tp]
	local g2 = Duel.GetMatchingGroup( cm.filter6, tp, LOCATION_GRAVE, 0, nil ,e,tp)
	local kx,zzx,sxx,zzjc,sxjc,zzl=it.sxbl()
	if Duel.Recover(tp,200,REASON_EFFECT)>0 then
	if num>=6 and #g2>0 and zzx>0 and xg.ky(tp,m,1) then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)
		local g = Duel.SelectMatchingCard(tp, nil, tp, LOCATION_GRAVE, 0, 1, 3, nil)
		Duel.SendtoDeck(g, nil, 2, REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
		local tc = Duel.SelectMatchingCard(tp, cm.filter6, tp, LOCATION_GRAVE, 0, 1, 1, nil ,e,tp):GetFirst()
		local zz,sx,lv=it.sxblx(tp,kx,zzx,sxx,zzl)
		if tc and Duel.IsPlayerCanSpecialSummonMonster(tp,tc:GetCode(),0,TYPE_NORMAL+TYPE_MONSTER,0,0,lv,zz,sx) then
			tc:AddMonsterAttribute(TYPE_NORMAL+TYPE_MONSTER,sx,zz,lv,0,0)
			Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP_DEFENSE)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetReset(RESET_EVENT+RESETS_REDIRECT)
			e3:SetValue(LOCATION_REMOVED)
			tc:RegisterEffect(e3,true)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e2:SetRange(LOCATION_MZONE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetReset(RESET_EVENT+RESETS_REDIRECT)
			e2:SetValue(cm.atkval)
			tc:RegisterEffect(e2)
			Duel.SpecialSummonComplete()

			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_FIELD)
			e4:SetCode(EFFECT_LIMIT_SPECIAL_SUMMON_POSITION)
			e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e4:SetTargetRange(1,0)
			e4:SetTarget(cm.sumlimit)
			Duel.RegisterEffect(e4,true)
		end
	end
	if num>=10 and xg.ky(tp,m,2) then
		if c:IsRelateToEffect(e) then
			Duel.SendtoDeck(c, nil, 2, REASON_EFFECT)
		end
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)
		local g = Duel.SelectMatchingCard(tp, cm.filter5, tp, LOCATION_GRAVE+QY_cs+QY_cw, LOCATION_GRAVE+QY_cs+QY_cw, 1, num, nil)
		Duel.SendtoDeck(g, nil, 2, REASON_EFFECT)
		Duel.RegisterFlagEffect(tp, m, SD_js, 0, 1)
	end
end
end
function cm.atkval(e,c)
	return Duel.GetMatchingGroupCount(cm.atkfilter,e:GetHandlerPlayer(),LOCATION_GRAVE+LOCATION_REMOVED,0,nil)*500
end
function cm.atkfilter(c)
	return aux.IsCodeListed(c, yr) and c:IsType(TYPE_EQUIP)
end