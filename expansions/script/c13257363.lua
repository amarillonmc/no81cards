--超时空战斗机-蛇牙
local m=13257363
local cm=_G["c"..m]
xpcall(function() require("expansions/script/tama") end,function() require("script/tama") end)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,6))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	e1:SetTarget(cm.drtg)
	e1:SetOperation(cm.drop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--cannot special summon
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e8:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e8)
	--special summon
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetCode(EFFECT_SPSUMMON_PROC)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e9:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e9:SetCondition(cm.hspcon)
	e9:SetTarget(cm.hsptg)
	e9:SetOperation(cm.hspop)
	c:RegisterEffect(e9)
	--Power Capsule
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCondition(cm.pccon)
	e3:SetTarget(cm.pctg)
	e3:SetOperation(cm.pcop)
	c:RegisterEffect(e3)
	eflist={{"power_capsule",e3}}
	cm[c]=eflist
	
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function cm.rfilter(c,tp)
	return (c:IsControler(tp) or c:IsFaceup()) and (c:IsSetCard(0x351) or c:IsCode(TAMA_OPTION_CODE))
end
function cm.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetReleaseGroup(tp,true):Filter(cm.rfilter,nil,tp)
	return rg:CheckSubGroup(aux.mzctcheck,2,2,tp)
end
function cm.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local rg=Duel.GetReleaseGroup(tp,true):Filter(cm.rfilter,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=rg:SelectSubGroup(tp,aux.mzctcheck,true,2,2,tp)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function cm.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_COST)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(m,7))
end
function cm.eqfilter(c,ec)
	return c:IsSetCard(0x352) and c:IsType(TYPE_MONSTER) and c:CheckEquipTarget(ec)
end
function cm.tdfilter(c,ec,tp)
	return c:IsSetCard(0x352) and c:IsType(TYPE_MONSTER) and c:IsFaceup() and ((c:CheckEquipTarget(ec) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0) or c:IsAbleToExtra())
end
function cm.pcfilter(c,tp)
	return c:GetPreviousControler()==tp and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function cm.pccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.pcfilter,1,nil,1-tp)
end
function cm.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local t1=true--Duel.IsExistingMatchingCard(cm.eqfilter,tp,LOCATION_EXTRA,0,1,nil,c) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	local t2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,TAMA_OPTION_CODE,0,TYPES_TOKEN_MONSTER,c:GetAttack(),c:GetDefense(),c:GetLevel(),c:GetRace(),c:GetAttribute())
	local t3=Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,c,tp)
	if chk==0 then return t1 or t2 or t3 end
	local op=0
	if t1 or t2 or t3 then
		local m1={}
		local n1={}
		local ct=1
		if t1 then m1[ct]=aux.Stringid(m,1) n1[ct]=1 ct=ct+1 end
		if t2 then m1[ct]=aux.Stringid(m,2) n1[ct]=2 ct=ct+1 end
		if t2 then m1[ct]=aux.Stringid(m,3) n1[ct]=3 ct=ct+1 end
		local sp=Duel.SelectOption(tp,table.unpack(m1))
		op=n1[sp+1]
	end
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_EQUIP)
		--Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_EXTRA)
	elseif op==2 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	end
end
function cm.pcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==1 then
		--[[
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,cm.eqfilter,tp,LOCATION_EXTRA,0,1,1,nil,c)
		if g:GetCount()>0 then
			local tc=g:GetFirst()
			Duel.Equip(tp,tc,c)
		end
		]]
		if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
		local eq=c:GetEquipGroup()
		local g=eq:Filter(Card.IsAbleToDeck,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,4)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local sg=g:Select(tp,1,1,nil)
			Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
		end
		if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,5)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			g=Duel.SelectMatchingCard(tp,cm.eqfilter,tp,LOCATION_EXTRA,0,1,1,nil,c)
			local tc=g:GetFirst()
			if tc then
				Duel.Equip(tp,tc,c)
			end
		end
	elseif e:GetLabel()==2 then
		local atk=c:GetAttack()
		local def=c:GetDefense()
		local lv=c:GetLevel()
		local race=c:GetRace()
		local att=c:GetAttribute()
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not c:IsRelateToEffect(e) or c:IsFacedown()
			or not Duel.IsPlayerCanSpecialSummonMonster(tp,TAMA_OPTION_CODE,0,TYPES_TOKEN_MONSTER,atk,def,lv,race,att) then return end
		local token=Duel.CreateToken(tp,TAMA_OPTION_CODE)
		c:CreateRelation(token,RESET_EVENT+RESETS_STANDARD)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(cm.tokenatk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		token:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetValue(cm.tokendef)
		token:RegisterEffect(e2,true)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CHANGE_LEVEL)
		e3:SetValue(cm.tokenlv)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		token:RegisterEffect(e3,true)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_CHANGE_RACE)
		e4:SetValue(cm.tokenrace)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		token:RegisterEffect(e4,true)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e5:SetValue(cm.tokenatt)
		e5:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		token:RegisterEffect(e5,true)
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetCode(EFFECT_SELF_DESTROY)
		e6:SetCondition(cm.tokendes)
		e6:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		token:RegisterEffect(e6,true)
		Duel.SpecialSummonComplete()
		c:SetCardTarget(token)
	elseif e:GetLabel()==3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,cm.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,c,tp)
		if c:IsRelateToEffect(e) and c:IsFaceup() and g:GetFirst():CheckEquipTarget(c) and Duel.GetLocationCount(tp,LOCATION_SZONE)>=g:GetCount() and Duel.SelectYesNo(tp,aux.Stringid(m,5)) then
			local tc=g:GetFirst()
			while tc do
				Duel.Equip(tp,tc,c,true,true)
				tc=g:GetNext()
			end
			Duel.EquipComplete()
		else
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		end
	end
end
function cm.tokenatk(e,c)
	return e:GetOwner():GetAttack()
end
function cm.tokendef(e,c)
	return e:GetOwner():GetDefense()
end
function cm.tokenlv(e,c)
	return e:GetOwner():GetLevel()
end
function cm.tokenrace(e,c)
	return e:GetOwner():GetRace()
end
function cm.tokenatt(e,c)
	return e:GetOwner():GetAttribute()
end
function cm.tokendes(e)
	return not e:GetOwner():IsRelateToCard(e:GetHandler())
end
