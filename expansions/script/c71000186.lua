--急袭猛禽 雷霆战绝猎鹰
local s,id,o=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,0,id,LOCATION_MZONE)
	--xyz summon
	aux.AddXyzProcedure(c,nil,9,4)
	c:EnableReviveLimit()
	--tograve
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(897409,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.tgcon)
	e1:SetTarget(s.tgtg)
	e1:SetOperation(s.tgop)
	c:RegisterEffect(e1)
	--effect lim 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(9)
	e3:SetCondition(s.limcon)
	e3:SetCost(s.limcost)
	e3:SetTarget(s.limtg)
	e3:SetOperation(s.limop)
	c:RegisterEffect(e3)
	--atk limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e4:SetCondition(s.atcon)
	e4:SetValue(s.atlimit)
	c:RegisterEffect(e4)
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonLocation(LOCATION_EXTRA)
end
function s.tgfilter(c)
	return c:IsSetCard(0xba) and c:IsAbleToGrave()
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.tgfilter,tp,LOCATION_DECK,0,nil)
	if #g==0 then return end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg1=g:SelectSubGroup(tp,aux.dncheck,false,1,3)
	Duel.SendtoGrave(tg1,REASON_EFFECT)
end
function s.limcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rc:IsType(TYPE_XYZ) and rc:IsSetCard(0xba) and rc~=e:GetHandler()
end
function s.limcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_COST) end
	Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_COST)
end
function s.change(chk)
	local ops={}
	for index=0,8 do 
		ops[index]=aux.Stringid(id,index-1)
	end 
	if not chk then return ops 
	elseif chk==0 then return TYPE_RITUAL 
	elseif chk==1 then return TYPE_FUSION 
	elseif chk==2 then return TYPE_SYNCHRO 
	elseif chk==3 then return TYPE_XYZ 
	elseif chk==4 then return TYPE_PENDULUM
	elseif chk==5 then return TYPE_LINK 
	elseif chk==6 then return TYPE_FIELD 
	elseif chk==7 then return TYPE_QUICKPLAY 
	elseif chk==8 then return TYPE_CONTINUOUS 
	else return false end
end
function s.limtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ops=s.change()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	Duel.SetTargetParam(Duel.SelectOption(tp,table.unpack(ops)))
end
function s.limop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local opt=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local ty=s.change(opt)
	if not ty then return end 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(s.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetLabel(ty)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetTargetRange(0,0xff)
	e2:SetTarget(s.disable)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetLabel(ty)
	Duel.RegisterEffect(e2,tp)
	c:RegisterFlagEffect(id,RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,opt,aux.Stringid(id,opt))
end
function s.aclimit(e,re,tp)
	local rc=re:GetHandler()
	return rc:IsType(e:GetLabel())
end
function s.disable(e,c)
	return c:IsType(e:GetLabel()) and (not c:IsType(TYPE_MONSTER) or (c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT))
end
function s.atcon(e)
	return e:GetHandler():IsDefensePos()
end
function s.atlimit(e,c)
	return c~=e:GetHandler()
end
