--梦见
yume=yume or {}
yume.temp_card_field=yume.temp_card_field or {}
if c71400001 then
function c71400001.initial_effect(c)
	if yume.import_flag then return	end
	--Activate(nofield)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c71400001.tg1)
	e1:SetCost(c71400001.cost)
	e1:SetOperation(c71400001.op1)
	e1:SetCountLimit(1,71400001+EFFECT_COUNT_CODE_OATH)
	e1:SetCategory(0)
	c:RegisterEffect(e1)
end
function c71400001.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c71400001.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=yume.YumeFieldCheck(tp,0,1)
	local b2=yume.IsYumeFieldOnField(tp) and Duel.IsExistingMatchingCard(c71400001.filter,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(71400001,2),aux.Stringid(71400001,0))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(71400001,2))
	else
		op=Duel.SelectOption(tp,aux.Stringid(71400001,0))+1
	end
	if op==0 then
		e:SetCategory(0)
		if not Duel.CheckPhaseActivity() then e:SetLabel(1,op) else e:SetLabel(0,op) end
	else
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
end
function c71400001.op1(e,tp,eg,ep,ev,re,r,rp)
	local act,op=e:GetLabel()
	if op==0 then
		yume.ActivateYumeField(e,tp,nil,1)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c71400001.filter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c71400001.filter(c)
	return c:IsSetCard(0x714) and c:IsAbleToHand() and not c:IsCode(71400001)
end
end
--global part
if not yume.yume_nikki then
yume.yume_nikki=true
function yume.AddYumeSummonLimit(c,ssm)
--1=special summon monster, 0=non special summon monster
	ssm=ssm or 0
	local el1=Effect.CreateEffect(c)
	el1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	el1:SetType(EFFECT_TYPE_SINGLE)
	el1:SetCode(EFFECT_SPSUMMON_CONDITION)
	el1:SetValue(yume.YumeCheck)
	c:RegisterEffect(el1)
	if ssm==0 then
		local el2=Effect.CreateEffect(c)
		el2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		el2:SetType(EFFECT_TYPE_SINGLE)
		el2:SetCode(EFFECT_CANNOT_MSET)
		el2:SetCondition(yume.YumeCheck2)
		c:RegisterEffect(el2)
		local el3=el2:Clone()
		el3:SetCode(EFFECT_CANNOT_SUMMON)
		c:RegisterEffect(el3)
	else
		c:EnableReviveLimit()
	end
end
function yume.GetValueType(v)
	local t=type(v)
	if t=="userdata" then
		local mt=getmetatable(v)
		if mt==Group then return "G"
		elseif mt==Effect then return "E"
		else return "C" end
	else return t end
end
function yume.YumeCheckFilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3714) and c:IsType(TYPE_FIELD)
end
function yume.IsYumeFieldOnField(tp)
	local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
	return fc and yume.YumeCheckFilter(fc)
end
--[[
Yume SpSummon check
v in effect = spsummon condition value(return true = can summon)
v in card = material filter generator(return true = can summon, se = set check)
--]]
function yume.YumeCheck(v,se,sp)
	local t=yume.GetValueType(v)
	if t=="E" then
		return yume.IsYumeFieldOnField(sp)
	elseif t=="C" then
		if se==true then
			return function(c)
				return c:IsSetCard(0x714) and yume.IsYumeFieldOnField(v:GetControler())
			end
		else return function(c)
				return yume.IsYumeFieldOnField(v:GetControler())
			end
		end
	end
end
--[[
Yume Link Material group filter generator
return true = can summon
--]]
function yume.YumeLMGFilterFunction(c)
	return function(g) return yume.IsYumeFieldOnField(c:GetControler()) and g:IsExists(Card.IsLinkSetCard,1,nil,0x714) end
end
--[[
Yume Summon/Set check
return true = cannot summon
--]]
function yume.YumeCheck2(e)
	return not yume.IsYumeFieldOnField(e:GetHandler():GetControler())
end
--Yume Condition
function yume.YumeCon(e,tp)
	if not tp then tp=e:GetHandlerPlayer() end
	return yume.IsYumeFieldOnField(tp)
end
function yume.nonYumeCon(e,tp,eg,ep,ev,re,r,rp)
	if not tp then tp=e:GetHandlerPlayer() end
	return not yume.IsYumeFieldOnField(tp)
end
function yume.RustCon(e,tp)
	if not tp then tp=e:GetHandlerPlayer() end
	return yume.IsRust(tp)
end
function yume.nonRustCon(e,tp)
	if not tp then tp=e:GetHandlerPlayer() end
	return not yume.IsRust(tp)
end
function yume.IsRust(tp)
	return Duel.GetFlagEffect(tp,71400038)>0
end
--ft=field type, 0-All Yume 1-Visionary Yume 2-Structured Yume
--loc=location
function yume.AddYumeFieldGlobal(c,id,ft)
	ft=ft or 0
	if not id then return end
	yume.temp_card_field[c]=yume.temp_card_field[c] or {}
	yume.temp_card_field[c].id=id
	yume.temp_card_field[c].ft=ft
	--Activate
	local eac=Effect.CreateEffect(c)
	eac:SetType(EFFECT_TYPE_ACTIVATE)
	eac:SetCode(EVENT_FREE_CHAIN)
	eac:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(eac)
	--activate field
	local efa=Effect.CreateEffect(c)
	efa:SetDescription(aux.Stringid(71400001,2))
	efa:SetCategory(EFFECT_TYPE_ACTIVATE)
	efa:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	efa:SetCode(EVENT_LEAVE_FIELD)
	efa:SetRange(LOCATION_FZONE)
	efa:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	efa:SetCondition(yume.ActivateFieldCon)
	efa:SetOperation(yume.ActivateFieldOp)
	c:RegisterEffect(efa)
end
function yume.AddYumeWeaponGlobal(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71400001,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetCondition(yume.YumeCon)
	--e1:SetCost(yume.WeaponSetCost)
	e1:SetTarget(yume.WeaponSetTg)
	e1:SetOperation(yume.WeaponSetOp)
	c:RegisterEffect(e1)
end
--activate field
function yume.WeaponSetCostFilter(c)
	return c:IsSetCard(0x714) and c:IsDiscardable()
end
function yume.WeaponSetCost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(yume.WeaponSetCostFilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,yume.WeaponSetCostFilter,1,1,REASON_COST+REASON_DISCARD)
end
function yume.WeaponSetTg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function yume.WeaponSetOp(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SSet(tp,c)
	end
end
function yume.YumeFieldCheck(tp,id,ft,loc)
	ft=ft or 0
	id=id or 0
	loc=loc or LOCATION_DECK
	return Duel.IsExistingMatchingCard(yume.ActivateFieldFilter,tp,loc,0,1,nil,tp,id,ft)
end
function yume.YumeFieldCheckTarget(id,ft,loc)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return yume.YumeFieldCheck(tp,id,ft,loc) end
		if not Duel.CheckPhaseActivity() then e:SetLabel(1) else e:SetLabel(0) end
	end
end
function yume.ActivateYumeField(e,tp,id,ft,loc)
	ft=ft or 0
	id=id or 0
	loc=loc or LOCATION_DECK
	local tc
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(71400001,3))
	if e:GetLabel()==1 then Duel.RegisterFlagEffect(tp,15248873,RESET_CHAIN,0,1) end
	if loc&LOCATION_GRAVE~=0 and loc~=LOCATION_GRAVE then
		tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(yume.ActivateFieldFilter),tp,loc,0,1,1,nil,tp,id,ft):GetFirst()
	else
		tc=Duel.SelectMatchingCard(tp,yume.ActivateFieldFilter,tp,loc,0,1,1,nil,tp,id,ft):GetFirst()
	end
	Duel.ResetFlagEffect(tp,15248873)
	if tc then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		te:UseCountLimit(tp,1,true)
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
		return tc
	end
	return nil
end
function yume.ActivateFieldFilter(c,tp,id,ft)
	local flag=c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp,true,true) and not c:IsCode(id)
	if ft==0 then return flag and c:IsSetCard(0x3714)
	elseif ft==1 then return flag and c:IsSetCard(0xb714)
	elseif ft==2 then return flag and c:IsSetCard(0x7714)
	end
end
function yume.ActivateFieldCon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function yume.ActivateFieldOp(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--local id=yume.temp_card_field[c].id
	local id=0
	local ft=yume.temp_card_field[c].ft
	yume.ActivateYumeField(e,tp,id,ft,LOCATION_DECK+LOCATION_HAND)
end
--uniquify the same name
function yume.UniquifyCardName(g)
	local tc=g:GetFirst()
	while tc do
		g:Remove(Card.IsCode,tc,tc:GetCode())
		tc=g:GetNext()
	end
end
function yume.HandleSelectionBorderList(blist)
	local lb1,ub1,lb2,ub2=1,1,1,1
	if blist then
		if blist[1] then
			lb1=blist[1][1] or lb1
			ub1=blist[1][2] or ub1
		end
		if blist[2] then
			lb2=blist[2][1] or lb2
			ub2=blist[2][2] or ub2
		end
	end
	return lb1,ub1,lb2,ub2
end
--Experimental quick algorithm for checking if there are ub1 cards from g1, including at least ub2 cards in g2
--Time complexity: O(nlogn)
---@param g1 Group
---@param g2 Group
---@param blist table|nil @A list for selection borders
---@return boolean
function yume.QuickInclusiveSelectCheck(g1,g2,blist)
	local lb1,_,lb2=yume.HandleSelectionBorderList(blist)
	local g3=g1&g2
	return #g1>lb1 and #g3>lb2
end
--Experimental quick algorithm for selecting ub1-ub2 cards from g1, including at least ub2 cards in g2
--Time complexity: O(nlogn)
---@param tp number
---@param g1 Group
---@param g2 Group
---@param blist table|nil @A list for selection borders
---@param msg number @Hint msg
---@return Group
function yume.QuickInclusiveSelect(tp,g1,g2,blist,msg)
	local resg=Group.CreateGroup()
	local lb1,ub1,lb2=yume.HandleSelectionBorderList(blist)
	local g3=g1&g2
	local rg=g1:Clone()
	if ub1>#g3 then ub1=#g3 end
	if #g1<lb1 or #g3<lb2 then return resg end
	--remaining borders
	local rlb1,rub1,rlb2=lb1,ub1,lb2
	local l=rlb1==0 and 0 or 1
	while rub1>0 do
		if rlb2>0 then
			if rub1==rlb2 then
				Duel.Hint(HINT_SELECTMSG,tp,msg)
				local sg=g3:Select(tp,rub1,rub1,nil)
				resg:Merge(sg)
				return resg
			else
				Duel.Hint(HINT_SELECTMSG,tp,msg)
				local sg=rg:Select(tp,l,1,nil)
				if #sg==0 then return resg end
				local sc=sg:GetFirst()
				resg:AddCard(sc)
				rg:RemoveCard(sc)
				rlb1,rub1=rlb1-1,rub1-1
				if rlb1==0 then l=0 end
				if g3:IsContains(sc) then
					rlb2=rlb2-1
					g3:RemoveCard(sc)
				end
			end
		else
			Duel.Hint(HINT_SELECTMSG,tp,msg)
			local sg=rg:Select(tp,rlb1,rub1,nil)
			resg:Merge(sg)
			return resg
		end
	end
	return resg
end
--Experimental quick algorithm for checking if there are enough cards from two groups, certain number for each group
--Time complexity: O(nlogn)
---@param g1 Group
---@param g2 Group
---@param blist table|nil @A list for selection borders
---@return boolean
function yume.QuickDualSelectCheck(g1,g2,blist)
	local lb1,_,lb2=yume.HandleSelectionBorderList(blist)
	local g3=g1+g2
	return #g1>=lb1 and #g2>=lb2 and #g3>=lb1+lb2
end
--Experimental quick algorithm for selecting cards from two groups, certain number for each group
--Time complexity: O(nlogn)
---@param tp number
---@param g1 Group
---@param g2 Group
---@param blist table|nil @A list for selection borders
---@param msg1 number @Hint msg 1
---@param msg2 number @Hint msg 2
---@param opf function? @A function for operations after selecting the first card, receiving the selected card as the first param and returning a bool standing for whether you do it("[opf], and if you do, select sg2")
---@param ... table
---@return Group,Group
function yume.QuickDualSelect(tp,g1,g2,blist,msg1,msg2,opf,...)
	local g3=g1&g2
	local g4=g2-g3
	local exgroup=nil
	local lb1,ub1,lb2,ub2=yume.HandleSelectionBorderList(blist)
	if #g2==lb2 and #(g1-g3)>=lb1 then
		exgroup=g3
	end
	if #g4<lb2 then
		local nxtub=#(g1+g4)-lb2
		if nxtub>=lb1 and ub1>nxtub then ub1=nxtub end
	end
	Duel.Hint(HINT_SELECTMSG,tp,msg1)
	local sg1=g1:Select(tp,lb1,ub1,exgroup)
	if not msg2 then return sg1 end
	local ext_params={...}
	if opf and not opf(sg1,table.unpack(ext_params)) then return sg1,Group.CreateGroup() end
	Duel.Hint(HINT_SELECTMSG,tp,msg2)
	local sg2=g2:Select(tp,lb2,ub2,sg1)
	return sg1,sg2
end
end