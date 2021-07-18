srre=srre or {}
local cm=srre
srre.loaded_metatable_list={}
--
function srre.load_metatable(code)
	local m1=_G["c"..code]
	if m1 then return m1 end
	local m2=srre.loaded_metatable_list[code]
	if m2 then return m2 end
	_G["c"..code]={}
	if pcall(function() dofile("expansions/script/c"..code..".lua") end) or pcall(function() dofile("script/c"..code..".lua") end) then
		local mt=_G["c"..code]
		_G["c"..code]=nil
		if mt then
			srre.loaded_metatable_list[code]=mt
			return mt
		end
	else
		_G["c"..code]=nil
	end
end
function srre.check_set(c,setcode,v,f,...) 
	local codet=nil
	if type(c)=="number" then
		codet={c}
	elseif type(c)=="table" then
		codet=c
	elseif type(c)=="userdata" then
		local f=f or Card.GetCode
		codet={f(c)}
	end
	local ncodet={...}
	for i,code in pairs(codet) do
		for i,ncode in pairs(ncodet) do
			if code==ncode then return true end
		end
		local mt=srre.load_metatable(code)
		if mt and mt["named_with_"..setcode] and (not v or mt["named_with_"..setcode]==v) then return true end
	end
	return false
end
--
function srre.check_set_SkyLand(c)  --天境
	return srre.check_set(c,"SkyLand")
end
function srre.check_set_HakaShiro(c)  --墓城
	return srre.check_set(c,"HakaShiro") or srre.check_set(c,"HakaShiroJyou") or srre.check_set(c,"SeHakaShiroJyou")
end
function srre.check_set_HakaShiroJyou(c)  --墓城姬
	return srre.check_set(c,"HakaShiroJyou") or srre.check_set(c,"SeHakaShiroJyou")
end
function srre.check_set_SeHakaShiroJyou(c)  --墓城七姬
	return srre.check_set(c,"SeHakaShiroJyou")
end
function srre.check_set_Mei(c)  --墓城七姬
	return srre.check_set(c,"Mei")
end
function srre.check_set_Unleashed(c)  --墓城姬
	return srre.check_set(c,"Unleashed")
end
function srre.check_set_Kanariya(c)  --卡娜莉雅
	return srre.check_set(c,"Kanariya")
end
function srre.check_set_IDA(c)  --
	return srre.check_set(c,"IDA")
end
function srre.SPSummoneffect(c,m,des,tt,cate,pro,limit,con,cost,tg,op)
	--tograve
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,des))
	if cate then
	e1:SetCategory(cate)
	end
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	if pro then
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	end
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	if limit then
	e1:SetCountLimit(table.unpack(limit))
	end
	if con then
	e1:SetCondition(con)
	end
	if cost then
	e1:SetCost(cost)
	end
	if tg then
	e1:SetTarget(tg)
	end
	e1:SetOperation(op)
	c:RegisterEffect(e1)
	if tt%4==1 then
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	end
	if tt%3==1 then
	local e3=e1:Clone()
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	end
end
function srre.SummonEffect(c,m,cate,pro,limit,con,cost,tg,op)
	--tograve
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	if cate then
	e1:SetCategory(cate)
	end
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	if pro then
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	end
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	if limit then
	e1:SetCountLimit(table.unpack(limit))
	end
	if con then
	e1:SetCondition(con)
	end
	if cost then
	e1:SetCost(cost)
	end
	if tg then
	e1:SetTarget(tg)
	end
	e1:SetOperation(op)
	c:RegisterEffect(e1)
	return e1
end
function srre.QFEffect(c,m,des,cate,pro,loc,limit,con,cost,tg,op)
	--Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(table.unpack(des)))
	e3:SetCategory(cate)
	if pro then
	e3:SetProperty(pro)
	end
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(loc)
	if limit then
	e3:SetCountLimit(table.unpack(limit))
	end
	e3:SetCode(EVENT_FREE_CHAIN)
	if timing then
	e3:SetHintTiming(0,timing)
	end
	if con then
	e3:SetCondition(con)
	end
	if cost then
	e3:SetCost(cost)
	end
	if tg then
	e3:SetTarget(tg)
	end
	e3:SetOperation(op)
	c:RegisterEffect(e3)
	return e3
end
function srre.SPSummon(c,m,des,limit,loc,con,op)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(table.unpack(des))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(loc)
	if limit then
	e1:SetCountLimit(table.unpack(limit))
	end
	if con then
	e1:SetCondition(con)
	end
	if op then
	e1:SetOperation(op)
	end
	c:RegisterEffect(e1)
	return e1
end
--  cm.srre_front_side=12026026
--  cm.srre_back_side=12026027
function srre.codechangeop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tcode=c.srre_back_side
	c:SetEntityCode(tcode,true)
	c:ReplaceEffect(tcode,0,0)
	Duel.Hint(HINT_CARD,1,tcode)
end
function srre.backeffect(c)
	--back
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_ADJUST)
	e0:SetRange(LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND+LOCATION_EXTRA)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e0:SetCountLimit(1)
	e0:SetCondition(srre.backon)
	e0:SetOperation(srre.backop)
	c:RegisterEffect(e0)
	return e0
end
function srre.backon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c.srre_front_side and c:GetOriginalCode()==c.srre_back_side
end
function srre.backop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tcode=c.srre_front_side
	c:SetEntityCode(tcode)
	if c:IsFacedown() then
	Duel.ConfirmCards(1-tp,Group.FromCards(c))
	end
	c:ReplaceEffect(tcode,0,0)
	Duel.Hint(HINT_CARD,1,tcode)
	if c:IsLocation(LOCATION_HAND) then
	local sp=c:GetControler()
	Duel.ShuffleHand(sp)
	end
end
function srre.negateeffect(c,m,des,cate,loc,limit,con,cost,tg,op)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(table.unpack(des)))
	e1:SetCategory(cate)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(loc)
	if limit then
	e1:SetCountLimit(table.unpack(limit))
	end
	if con then
	e1:SetCondition(con)
	end
	if cost then
	e1:SetCost(cost)
	end
	if tg then
	e1:SetTarget(tg)
	end
	if op then
	e1:SetOperation(op)
	end
	c:RegisterEffect(e1)
	return e1
end
--immune
function srre.immuneffect(c,cc,sum)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	if cc and cc==1 then
	e1:SetValue(srre.atefilter)
	end
	if sum then
	e1:SetCondition(function(e,sum)
return e:GetHandler():IsSummonType(sum)
end)
	end
	c:RegisterEffect(e1)
	return e1
end
function srre.atefilter(e,re,tp)
	return re:GetHandlerPlayer()~=e:GetHandlerPlayer()
end
function srre.atk_up(c,val,def)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(val)
	c:RegisterEffect(e1)
	if def then
	e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(val)
	c:RegisterEffect(e2)
	end
	return e1 and e2
end
function srre.level_Redirect(c,val,reset)
	local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		if reset then
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		end
		e1:SetValue(val)
		c:RegisterEffect(e1,true)
	 return e1
end