--久远的传承
local m=16670007
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
--	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
    --
    if not c16670007.global_check then
		c16670007.global_check={}
	--	local ge1=Effect.GlobalEffect(c)
	--	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	--	ge1:SetCode(EVENT_TO_GRAVE)
	--	ge1:SetCondition(c16670007.checkcon)
	--	ge1:SetOperation(c16670007.checkop)
	--	Duel.RegisterEffect(ge1,0)
	end
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		local code1=g:GetFirst()
        local code=g:GetFirst():GetOriginalCodeRule()
		local cid=0
        local cid2=0
		local ua=false
		local token=true
		local mt={}
        for tc,num in pairs(c16670007.global_check) do
          cid=num
		  token=Duel.CreateToken(tp,num)
		  mt=getmetatable(token)
		cm.reg =Card.RegisterEffect
		Card.RegisterEffect = cm.reg2
		if mt.initial_effect then
			mt.initial_effect(code1)
		end
		Card.RegisterEffect = cm.reg
     -- cid2=code1:CopyEffect(cid,RESET_EVENT+RESETS_STANDARD,1)
	 --	Duel.MajesticCopy(code1,token)
        end
		for i,v in pairs(c16670007.global_check) do
			if v==code then
				ua=true
			end
		end
        if ua==false then
			table.insert(c16670007.global_check,code)
		end
        local e1_1=Effect.CreateEffect(c)
		e1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1_1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1_1:SetRange(LOCATION_MZONE)
		e1_1:SetCode(EVENT_LEAVE_FIELD)
		e1_1:SetTarget(cm.tg1)
		e1_1:SetOperation(cm.op1)
     --	e1_1:SetReset(RESET_EVENT+0x1fe0000)
		code1:RegisterEffect(e1_1)
		--
		local e1_2=Effect.CreateEffect(c)
		e1_2:SetDescription(aux.Stringid(16670007,0))
		e1_2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1_2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1_2:SetRange(LOCATION_MZONE)
		e1_2:SetCode(EVENT_LEAVE_FIELD)
    	e1_2:SetReset(RESET_EVENT+0x1fe0000)
		code1:RegisterEffect(e1_2)
		--
        local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_LEAVE_FIELD)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e3:SetCountLimit(1)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		e3:SetLabelObject(e1_1)
		e3:SetLabel(cid2)
		e3:SetOperation(cm.rstop)
		code1:RegisterEffect(e3)
		--
        end
		local ap=e:GetType()
		if ap~=EFFECT_TYPE_ACTIVATE then
			e:Reset()
		end
end
--
function cm.rstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cid=e:GetLabel()
	if cid~=0 then
		c:ResetEffect(cid,RESET_COPY)
		c:ResetEffect(RESET_DISABLE,RESET_EVENT)
	end
	local e1=e:GetLabelObject()
	local e2=e:GetProperty()
	e1:Reset()
end
function cm.reg2(c,e,ob)
	local b=ob or false
	if e:IsHasType(EFFECT_TYPE_QUICK_F) then
		e:SetType((e:GetType()-EFFECT_TYPE_QUICK_F)|EFFECT_TYPE_QUICK_O)
		local flag1,flag2=e:GetProperty()
		e:SetProperty(flag1|EFFECT_FLAG_DELAY,flag2)
	end
	if e:IsHasType(EFFECT_TYPE_TRIGGER_F) then
		e:SetType((e:GetType()-EFFECT_TYPE_TRIGGER_F)|EFFECT_TYPE_TRIGGER_O)
	end
	e:SetReset(RESET_EVENT+RESETS_STANDARD)
	if not e:IsActivated() then e:Reset() 
	else
		cm.reg(c,e,b)
	end
end
