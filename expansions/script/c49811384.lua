--ガーディアン・インターソウル
local cm,m=GetID()

function cm.initial_effect(c)
	aux.AddCodeList(c,34022290)
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,34022290,18175965,true,true)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(cm.sprcon)
	e2:SetTarget(cm.sprtg)
	e2:SetOperation(cm.sprop)
	c:RegisterEffect(e2)
	--equip
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_EQUIP)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetTarget(cm.eqtg)
	e5:SetOperation(cm.eqop)
	c:RegisterEffect(e5)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(0x04)
	e4:SetCountLimit(1)
	e4:SetCondition(cm.tgcon)
	e4:SetTarget(cm.tgtg)
	e4:SetOperation(cm.tgop)
	c:RegisterEffect(e4)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(0x14)
	e3:SetCondition(cm.tdcon)
	e3:SetCost(cm.tdcost)
	e3:SetTarget(cm.tdtg)
	e3:SetOperation(cm.tdop)
	c:RegisterEffect(e3)
end

function cm.sprfilter(c)
	return not c:IsPublic() and c:IsSetCard(0x52) and c:IsType(0x1) and c:IsLevelBelow(5)
end

function cm.sprcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and Duel.IsExistingMatchingCard(cm.sprfilter,c:GetControler(),0x02,0,1,nil) 
end

function cm.sprtg(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tc=Duel.SelectMatchingCard(tp,cm.sprfilter,tp,0x02,0,1,1,nil):GetFirst()
	e:SetLabelObject(tc)
	if tc then return true end
end

function cm.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local tc=e:GetLabelObject()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,tc:GetFieldID(),66)
end

--怪兽上有装备记述穷举,未添加接口
local equiparray={{9633505,95515060},{10755153,95638658},{18175965,81954378},{46037213,21900719},{47150851,32022366},{73544866,68427465},{74367458,69243953}}

function cm.eqfilter(c,code)
	return c:IsPublic() and c:IsCode(code) and c:IsSetCard(0x52)
end

function cm.filter(c,tp,ec)
	if not (c:CheckEquipTarget(ec) and not c:IsForbidden() and c:CheckUniqueOnField(tp)) then return false end
	for i, v in ipairs(equiparray) do
		if c:IsCode(equiparray[i][2]) and Duel.IsExistingMatchingCard(cm.eqfilter,tp,0x02,0,1,nil,equiparray[i][1]) then return true end
	end
end

function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,0x08)>0 and Duel.IsExistingMatchingCard(cm.filter,tp,0x01,0,1,nil,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
end

function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or not c:IsRelateToChain() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,tp,c)
	if g:GetCount()>0 then
		Duel.Equip(tp,g:GetFirst(),c)
	end
end

function cm.contfilter(c)
	return c:IsPreviousLocation(0x0c) and c:GetPreviousTypeOnField()&TYPE_EQUIP~=0
end

function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.contfilter,1,nil)
end

function cm.tgfilter2(c,tc)
	return c:IsFaceup() and tc:CheckEquipTarget(c)
end

function cm.tgfilter(c,tp)
	return c:GetType()==0x40002 and c:CheckUniqueOnField(tp) and not c:IsForbidden() and Duel.IsExistingMatchingCard(cm.tgfilter2,tp,0x04,0,1,nil,c)
end

function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,0x08)>0 and Duel.IsExistingMatchingCard(cm.tgfilter,tp,0x10,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,0x10)
end

function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.tgfilter),tp,0x10,0,1,1,nil,tp):GetFirst()
	if tc then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local ec=Duel.SelectMatchingCard(tp,cm.tgfilter2,tp,0x04,0,1,1,nil,tc):GetFirst()
		if ec and Duel.Equip(tp,tc,ec) then
			--送去墓地时效果适用
			local Equip_table_effect=cm.geteffect(tc)
			if #Equip_table_effect==1 then
				local effect=table.unpack(Equip_table_effect)
				local tg=effect:GetTarget()
				local op=effect:GetOperation()
				tc:RegisterEffect(effect)
				tc:CreateEffectRelation(effect)
				if not (not tg or tg(effect,tp,eg,ep,ev,re,r,rp,0)) then return end
				Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
				if tg then tg(effect,tp,eg,ep,ev,re,r,rp,1) end
				local ttg=Group.CreateGroup()
				local ttg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
				if ttg then
					local ttg2=ttg:GetFirst()
					while ttg2 do
						ttg2:CreateEffectRelation(effect)
						ttg2=ttg:GetNext()
					end
				end
				if op then op(effect,tp,eg,ep,ev,re,r,rp,1) end
				tc:ReleaseEffectRelation(effect)
				if ttg then
					local ttg2=ttg:GetFirst()
					while ttg2 do
						ttg2:ReleaseEffectRelation(effect)
						ttg2=ttg:GetNext()
					end
				end
				effect:Reset()
			elseif #Equip_table_effect==2 then
				Duel.ClearTargetCard()
				local effect1,effect2=table.unpack(Equip_table_effect)
				local tg1=effect1:GetTarget()
				local tg2=effect2:GetTarget()
				local op=0
				tc:RegisterEffect(effect1)
				tc:CreateEffectRelation(effect1)
				tc:RegisterEffect(effect2)
				tc:CreateEffectRelation(effect2)
				if (not tg1 or tg1(effect1,tp,eg,ep,ev,re,r,rp,0)) and not (not tg2 or tg2(effect2,tp,eg,ep,ev,re,r,rp,0)) then op=Duel.SelectOption(tp,effect1:GetDescription())+1
				elseif (not tg2 or tg2(effect2,tp,eg,ep,ev,re,r,rp,0)) and not (not tg1 or tg1(effect1,tp,eg,ep,ev,re,r,rp,0)) then op=Duel.SelectOption(tp,effect2:GetDescription())+2 
				elseif (not tg1 or tg1(effect1,tp,eg,ep,ev,re,r,rp,0)) and (not tg2 or tg2(effect2,tp,eg,ep,ev,re,r,rp,0)) then op=Duel.SelectOption(tp,effect1:GetDescription(),effect2:GetDescription())+1
				end
				if op==1 then
					local tg=effect1:GetTarget()
					local op=effect1:GetOperation()
					if not (not tg or tg(effect1,tp,eg,ep,ev,re,r,rp,0)) then return end
					Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
					if tg then tg(effect1,tp,eg,ep,ev,re,r,rp) end
					local ttg=Group.CreateGroup()
					local ttg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
					if ttg then
						local ttg2=ttg:GetFirst()
						while ttg2 do
							ttg2:CreateEffectRelation(effect1)
							ttg2=ttg:GetNext()
						end
					end
					if op then op(effect1,tp,eg,ep,ev,re,r,rp) end
					if ttg then
						local ttg2=ttg:GetFirst()
						while ttg2 do
							ttg2:ReleaseEffectRelation(effect1)
							ttg2=ttg:GetNext()
						end
					end
				elseif op==2 then
					local tg=effect2:GetTarget()
					local op=effect2:GetOperation()
					if not (not tg or tg(effect2,tp,eg,ep,ev,re,r,rp,0)) then return end
					Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
					if tg then tg(effect2,tp,eg,ep,ev,re,r,rp) end
					local ttg=Group.CreateGroup()
					local ttg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
					if ttg then
						local ttg2=ttg:GetFirst()
						while ttg2 do
							ttg2:CreateEffectRelation(effect2)
							ttg2=ttg:GetNext()
						end
					end
					if op then op(effect2,tp,eg,ep,ev,re,r,rp) end
					if ttg then
						local ttg2=ttg:GetFirst()
						while ttg2 do
							ttg2:ReleaseEffectRelation(effect2)
							ttg2=ttg:GetNext()
						end
					end
				end
				tc:ReleaseEffectRelation(effect1)
				effect1:Reset()
				tc:ReleaseEffectRelation(effect2)
				effect2:Reset()
			end
		end
	end
end

function cm.geteffect(c)
	cregister=Card.RegisterEffect
	table_effect={}
	Card.RegisterEffect=function(card,effect,flag)
		if effect and (effect:GetCode()==EVENT_TO_GRAVE and (effect:IsHasType(EFFECT_TYPE_TRIGGER_O) or effect:IsHasType(EFFECT_TYPE_TRIGGER_F)) and effect:IsHasType(EFFECT_TYPE_SINGLE)) then
			local eff=effect:Clone()
			table.insert(table_effect,eff)
		end
		return 
	end
	table_effect={}
	Duel.CreateToken(0,c:GetOriginalCode())
	Card.RegisterEffect=cregister
	return table_effect
end

function cm.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end

function cm.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToExtraAsCost() end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end

function cm.tgtfilter(c)
	return c:IsCode(18175965) and c:IsAbleToHand()
end

function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x01)
end

function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.tgtfilter,tp,0x01,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end