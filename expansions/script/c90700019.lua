--last upd 2022-7-2
Seine_clock_tower={}
local zl=_G["Seine_clock_tower"]
zl.wind_code=90700013
zl.dark_code=90700014
zl.light_code=90700015
zl.fire_code=90700016
zl.water_code=90700017
zl.earth_code=90700018
zl.field=90700019
zl.link_code=90700020
function zl.enable(c)
	aux.AddCodeList(c,zl.field)
	if c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK) then
		aux.EnablePendulumAttribute(c,false)
	else
		aux.EnablePendulumAttribute(c)
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CHANGE_LSCALE)
	e2:SetValue(5)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCode(EFFECT_CHANGE_RSCALE)
	e3:SetValue(7)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetRange(0x1ff)
	e4:SetCode(c:GetOriginalCodeRule())
	c:RegisterEffect(e4)
	if not zl.global_enable then
		zl.global_enable=true
		zl.global_enable_op(c)
	end
end
function zl.pubcon(e)
	return e:GetHandler():IsPublic()
end
function zl.global_enable_op(c)
	local e_win=Effect.CreateEffect(c)
	e_win:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e_win:SetCode(EVENT_ADJUST)
	e_win:SetProperty(EFFECT_FLAG_DELAY)
	e_win:SetCondition(zl.wincon)
	e_win:SetOperation(zl.winop)
	Duel.RegisterEffect(e_win,0)
	local e_wind=Effect.CreateEffect(c)
	e_wind:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e_wind:SetCode(EVENT_CHAIN_SOLVING)
	e_wind:SetOperation(zl.wind_op)
	Duel.RegisterEffect(e_wind,0)
	local e_dark=Effect.CreateEffect(c)
	e_dark:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e_dark:SetCode(EVENT_CHAIN_SOLVING)
	e_dark:SetOperation(zl.dark_op)
	Duel.RegisterEffect(e_dark,0)
	local e_light_1=Effect.CreateEffect(c)
	e_light_1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e_light_1:SetCode(EVENT_SUMMON)
	e_light_1:SetOperation(zl.light_op)
	Duel.RegisterEffect(e_light_1,0)
	local e_light_2=Effect.Clone(e_light_1)
	e_light_2:SetCode(EVENT_FLIP_SUMMON)
	Duel.RegisterEffect(e_light_2,0)
	local e_light_3=Effect.Clone(e_light_1)
	e_light_3:SetCode(EVENT_SPSUMMON)
	Duel.RegisterEffect(e_light_3,0)
	local e_th=Effect.CreateEffect(c)
	e_th:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e_th:SetCode(EVENT_TO_HAND)
	e_th:SetCondition(zl.th_con)
	e_th:SetOperation(zl.th_op)
	Duel.RegisterEffect(e_th,0)
	local e_water=Effect.CreateEffect(c)
	e_water:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e_water:SetCode(EVENT_PHASE_START+PHASE_END)
	e_water:SetOperation(zl.water_op)
	Duel.RegisterEffect(e_water,0)
end
function zl.winfilter(c)
	return aux.IsCodeListed(c,zl.field) and c:IsType(TYPE_MONSTER)
end
function zl.win_check(g)
	return g:Filter(zl.winfilter,nil):GetClassCount(Card.GetOriginalAttribute)==6
end
function zl.wincon(e,tp,eg,ep,ev,re,r,rp)
	return zl.win_check(Duel.GetFieldGroup(0,LOCATION_HAND,0)) or zl.win_check(Duel.GetFieldGroup(1,LOCATION_HAND,0))
end
function zl.winop(e,tp,eg,ep,ev,re,r,rp)
	local winmessage=0x60
	local gp0=Duel.GetFieldGroup(0,LOCATION_HAND,0)
	local gp1=Duel.GetFieldGroup(1,LOCATION_HAND,0)
	local wp0=zl.win_check(gp0)
	local wp1=zl.win_check(gp1)
	if wp0 and not wp1 then
		Duel.ConfirmCards(1,gp0)
		Duel.Win(0,winmessage)
	elseif not wp0 and wp1 then
		Duel.ConfirmCards(0,gp1)
		Duel.Win(1,winmessage)
	elseif wp0 and wp1 then
		Duel.ConfirmCards(0,gp0)
		Duel.ConfirmCards(1,gp1)
		Duel.Win(PLAYER_NONE,winmessage)
	end
end
function zl.th_filter(c,code)
	local con1=c:IsAbleToHandAsCost()
	local con2=c:IsLocation(LOCATION_DECK)
	local con3=c:IsLocation(LOCATION_ONFIELD) and c:IsPosition(POS_FACEUP)
	local con4=c:IsHasEffect(code)
	return con1 and (con2 or con3) and con4
end
function zl.wind_op(e,tp,eg,ep,ev,re,r,rp)
	local actp=re:GetHandlerPlayer()
	local oppp=1-actp
	local check1=re:IsActiveType(TYPE_SPELL)
	local check2=re:IsActiveType(TYPE_TRAP)
	local check3=Duel.IsPlayerCanDraw(actp,1)
	if not ((check1 or check2) and check3) then return end
	local solve=false
	local thc
	local actg=Duel.GetMatchingGroup(zl.th_filter,actp,LOCATION_ONFIELD+LOCATION_DECK,0,nil,zl.wind_code)
	if actg and #actg>0 and Duel.SelectYesNo(actp,aux.Stringid(zl.field,1)) then
		Duel.Hint(HINT_SELECTMSG,actp,HINTMSG_ATOHAND)
		thc=actg:Select(actp,1,1,nil):GetFirst()
		solve=true
	end
	local oppg=Duel.GetMatchingGroup(zl.th_filter,oppp,LOCATION_ONFIELD+LOCATION_DECK,0,nil,zl.wind_code)
	if not solve and oppg and #oppg>0 and Duel.SelectYesNo(oppp,aux.Stringid(zl.field,1)) then
		Duel.Hint(HINT_SELECTMSG,oppp,HINTMSG_ATOHAND)
		thc=oppg:Select(oppp,1,1,nil):GetFirst()
		solve=true
	end
	if solve then
		Duel.Hint(HINT_CARD,0,zl.wind_code)
		Duel.SendtoHand(thc,nil,REASON_COST)
		if thc:IsPreviousLocation(LOCATION_DECK) then
			local e1=Effect.CreateEffect(thc)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetDescription(aux.Stringid(zl.field,9))
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetCode(EFFECT_PUBLIC)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			thc:RegisterEffect(e1)
		end
		Duel.BreakEffect()
		Duel.Draw(actp,1,REASON_EFFECT)
		Duel.NegateEffect(ev)
		local rc=re:GetHandler()
		local e1=Effect.CreateEffect(thc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(thc)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e2)
	end
end
function zl.dark_op(e,tp,eg,ep,ev,re,r,rp)
	local actp=re:GetHandlerPlayer()
	local oppp=1-actp
	local check1=re:IsActiveType(TYPE_MONSTER)
	local check2=Duel.IsPlayerCanDraw(actp,1)
	if not (check1 and check2) then return end
	local solve=false
	local thc
	local actg=Duel.GetMatchingGroup(zl.th_filter,actp,LOCATION_ONFIELD+LOCATION_DECK,0,nil,zl.dark_code)
	if actg and #actg>0 and Duel.SelectYesNo(actp,aux.Stringid(zl.field,2)) then
		Duel.Hint(HINT_SELECTMSG,actp,HINTMSG_ATOHAND)
		thc=actg:Select(actp,1,1,nil):GetFirst()
		solve=true
	end
	local oppg=Duel.GetMatchingGroup(zl.th_filter,oppp,LOCATION_ONFIELD+LOCATION_DECK,0,nil,zl.dark_code)
	if not solve and oppg and #oppg>0 and Duel.SelectYesNo(oppp,aux.Stringid(zl.field,2)) then
		Duel.Hint(HINT_SELECTMSG,oppp,HINTMSG_ATOHAND)
		thc=oppg:Select(oppp,1,1,nil):GetFirst()
		solve=true
	end
	if solve then
		Duel.Hint(HINT_CARD,0,zl.dark_code)
		Duel.SendtoHand(thc,nil,REASON_COST)
		if thc:IsPreviousLocation(LOCATION_DECK) then
			local e1=Effect.CreateEffect(thc)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_PUBLIC)
			e1:SetDescription(aux.Stringid(zl.field,9))
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			thc:RegisterEffect(e1)
		end
		Duel.BreakEffect()
		Duel.Draw(actp,1,REASON_EFFECT)
		Duel.NegateEffect(ev)
		local rc=re:GetHandler()
		local e1=Effect.CreateEffect(thc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(thc)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e2)
	end
end
function zl.light_op(e,tp,eg,ep,ev,re,r,rp)
	local actp=rp
	local oppp=1-actp
	local solve=false
	local thc
	local actg=Duel.GetMatchingGroup(zl.th_filter,actp,LOCATION_ONFIELD+LOCATION_DECK,0,nil,zl.light_code)
	if actg and #actg>0 and Duel.SelectYesNo(actp,aux.Stringid(zl.field,3)) then
		Duel.Hint(HINT_SELECTMSG,actp,HINTMSG_ATOHAND)
		thc=actg:Select(actp,1,1,nil):GetFirst()
		solve=true
	end
	local oppg=Duel.GetMatchingGroup(zl.th_filter,oppp,LOCATION_ONFIELD+LOCATION_DECK,0,nil,zl.light_code)
	if not solve and oppg and #oppg>0 and Duel.SelectYesNo(oppp,aux.Stringid(zl.field,3)) then
		Duel.Hint(HINT_SELECTMSG,oppp,HINTMSG_ATOHAND)
		thc=oppg:Select(oppp,1,1,nil):GetFirst()
		solve=true
	end
	if solve then
		Duel.Hint(HINT_CARD,0,zl.light_code)
		Duel.SendtoHand(thc,nil,REASON_COST)
		if thc:IsPreviousLocation(LOCATION_DECK) then
			local e1=Effect.CreateEffect(thc)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetDescription(aux.Stringid(zl.field,9))
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetCode(EFFECT_PUBLIC)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			thc:RegisterEffect(e1)
		end
		Duel.BreakEffect()
		Duel.Remove(eg,POS_FACEDOWN,REASON_RULE)
	end
end
function zl.th_trigger_filter(c)
	local con1=aux.IsCodeListed(c,zl.field)
	local con2=c:IsPreviousLocation(LOCATION_DECK) and not c:IsReason(REASON_DRAW)
	local con3=c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP)
	local con4=c:IsCode(zl.fire_code,zl.water_code,zl.earth_code)
	return con1 and (con2 or con3) and not con4
end
function zl.th_con_filter(c,code)
	return c:IsPublic() and c:IsCode(code)
end
function zl.sel_thc_op_attr(p,code)
	local g=Duel.GetMatchingGroup(zl.th_filter,p,LOCATION_ONFIELD+LOCATION_DECK,0,nil,code)
	local con=Duel.GetMatchingGroupCount(zl.th_con_filter,actp,LOCATION_HAND,0,nil,code)==0
	if con and g and #g>0 and Duel.SelectYesNo(p,aux.Stringid(zl.field,code-zl.wind_code+1)) then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
		local c=g:Select(p,1,1,nil):GetFirst()
		return c
	end
	return nil
end
function zl.sel_thc_op(p)
	local g=Group.CreateGroup()
	local fire_card=zl.sel_thc_op_attr(p,zl.fire_code)
	if fire_card then g:AddCard(fire_card) end
	local earth_card=zl.sel_thc_op_attr(p,zl.earth_code)
	if earth_card then g:AddCard(earth_card) end
	g:KeepAlive()
	return g
end
zl.tod_sel_g=Group.CreateGroup()
function zl.fire_count_filter(c)
	return not c:IsPublic()
end
function zl.th_fire_solve(p,card)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,p,LOCATION_HAND,0,zl.tod_sel_g)
	if g and #g>0 and Duel.SelectYesNo(p,aux.Stringid(zl.field,7)) then
		Duel.Hint(HINT_CARD,0,zl.fire_code)
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
		local tdg=g:Select(p,1,#g-1,card)
		zl.tod_sel_g:Merge(tdg)
		local num=tdg:FilterCount(zl.fire_count_filter,nil)
		local opg=Duel.GetMatchingGroup(Card.IsAbleToDeck,1-p,LOCATION_HAND,0,zl.tod_sel_g):Filter(zl.fire_count_filter,nil)
		if num>#opg then num=#opg end
		local sg=opg:Select(1-p,num,num,nil)
		zl.tod_sel_g:Merge(sg)
	end
end
zl.ban_sel_g=Group.CreateGroup()
function zl.earth_count_filter(c)
	return aux.IsCodeListed(c,90700019) and c:IsType(TYPE_MONSTER)
end
function zl.th_earth_solve(p)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,p,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,zl.ban_sel_g,p)
	if g and #g>0 and Duel.SelectYesNo(p,aux.Stringid(zl.field,8)) then
		Duel.Hint(HINT_CARD,0,zl.earth_code)
		local hand=Duel.GetFieldGroup(p,LOCATION_HAND,0)
		Duel.ConfirmCards(1-p,hand)
		local num=hand:Filter(zl.earth_count_filter,nil):GetClassCount(Card.GetAttribute)
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_REMOVE)
		local sg=Duel.SelectMatchingCard(p,aux.NecroValleyFilter(Card.IsAbleToRemove),p,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,num,zl.ban_sel_g,p)
		zl.ban_sel_g:Merge(sg)
	end
end
function zl.th_solve(p,g)
	Duel.SendtoHand(g,nil,REASON_COST)
	local flag=0
	local fire_card
	g:ForEach(
		function(thc)
			Duel.Hint(HINT_CARD,0,thc:GetCode())
			if thc:IsCode(zl.fire_code) then
				flag=bit.bor(flag,0x2)
				fire_card=thc
			end
			if thc:IsCode(zl.earth_code) then flag=bit.bor(flag,0x1) end
			if thc:IsPreviousLocation(LOCATION_DECK) then
				local e1=Effect.CreateEffect(thc)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_PUBLIC)
				e1:SetDescription(aux.Stringid(zl.field,9))
				e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				thc:RegisterEffect(e1)
			end
		end
	)
	g:DeleteGroup()
	if bit.band(flag,0x2)~=0 then
		zl.th_fire_solve(p,fire_card)
	end
	if bit.band(flag,0x1)~=0 then
		zl.th_earth_solve(p)
	end
end
function zl.th_con(e,tp,eg,ep,ev,re,r,rp)
	return eg:FilterCount(zl.th_trigger_filter,nil)>0
end
function zl.th_op(e,tp,eg,ep,ev,re,r,rp)
	local actp=Duel.GetTurnPlayer()
	local oppp=1-actp
	local actp_th_g=zl.sel_thc_op(actp)
	local oppp_th_g=zl.sel_thc_op(oppp)
	if #actp_th_g>0 then zl.th_solve(actp,actp_th_g) end
	if #oppp_th_g>0 then zl.th_solve(oppp,oppp_th_g) end
	if zl.tod_sel_g:GetCount()>0 or zl.ban_sel_g:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SendtoDeck(zl.tod_sel_g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		Duel.Remove(zl.ban_sel_g,POS_FACEDOWN,REASON_EFFECT)
		zl.tod_sel_g:Clear()
		zl.ban_sel_g:Clear()
	end
end
function zl.water_op(e,tp,eg,ep,ev,re,r,rp)
	local actp=Duel.GetTurnPlayer()
	local oppp=1-actp
	local actg=Duel.GetMatchingGroup(zl.th_filter,actp,LOCATION_ONFIELD+LOCATION_DECK,0,nil,zl.water_code)
	if actg and #actg>0 and Duel.SelectYesNo(actp,aux.Stringid(zl.field,5)) then
		Duel.Hint(HINT_CARD,0,zl.water_code)
		Duel.Hint(HINT_SELECTMSG,actp,HINTMSG_ATOHAND)
		local thc=actg:Select(actp,1,1,nil):GetFirst()
		Duel.SendtoHand(thc,nil,REASON_COST)
		if thc:IsPreviousLocation(LOCATION_DECK) then
			local e1=Effect.CreateEffect(thc)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_PUBLIC)
			e1:SetDescription(aux.Stringid(zl.field,9))
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			thc:RegisterEffect(e1)
		end
	end
	local oppg=Duel.GetMatchingGroup(zl.th_filter,oppp,LOCATION_ONFIELD+LOCATION_DECK,0,nil,zl.water_code)
	if  oppg and #oppg>0 and Duel.SelectYesNo(oppp,aux.Stringid(zl.field,5)) then
		Duel.Hint(HINT_CARD,0,zl.water_code)
		Duel.Hint(HINT_SELECTMSG,oppp,HINTMSG_ATOHAND)
		local thc=oppg:Select(oppp,1,1,nil):GetFirst()
		Duel.SendtoHand(thc,nil,REASON_COST)
		if thc:IsPreviousLocation(LOCATION_DECK) then
			local e1=Effect.CreateEffect(thc)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetDescription(aux.Stringid(zl.field,9))
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetCode(EFFECT_PUBLIC)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			thc:RegisterEffect(e1)
		end
	end
end