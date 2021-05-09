--翼龙的你
if bm then return end
bm=bm or {}
local Version_Number=20210414
bm.name=71000111

--Instructions about how to use this
--[[
if not pcall(function() require("expansions/script/c71000111") end) then
	if not pcall(function() require("script/c71000111") end) then
		require("c71000111")
	end
end
--]]
bm.b=bm.b or {} --base fun
bm.e=bm.e or {} --others effect fun
bm.c=bm.c or {} --check fun
bm.r=bm.r or {}
bm.re=bm.re or {}
bm.hint=bm.hint or {}

--hint 
bm.hint.set =   aux.Stringid(2521011,0)  --"set"
bm.hint.move=   aux.Stringid(22198672,0)	--"move"
bm.hint.tog =   aux.Stringid(1050186,0)  --"to grave"
bm.hint.sps =   aux.Stringid(39015,0)   --"special summon"
bm.hint.nege=   aux.Stringid(1621413,1)  --"NegateEffect"
bm.hint.des =   aux.Stringid(698785,0)  --"Destroy"
bm.hint.lvd =   aux.Stringid(17330916,0)--"level down"
bm.hint.th  =   aux.Stringid(123709,2)  --"to hand"
bm.hint.rmm =   aux.Stringid(811734,0)  --"Remove monster"

--Reset Variable
bm.r.s =   RESET_EVENT+RESETS_STANDARD 
bm.r.d =   RESET_DISABLE 
bm.r.e =   RESET_PHASE+PHASE_END  
bm.r.p =   RESET_PHASE+PHASE_STANDBY 

--Reason 
bm.re.e =  REASON_EFFECT 
bm.re.c =  REASON_COST 

--Location Variable
mz=LOCATION_MZONE 
pz=LOCATION_PZONE 
ex=LOCATION_EXTRA 
dk=LOCATION_DECK 
ga=LOCATION_GRAVE 
sz=LOCATION_SZONE 
of=LOCATION_ONFIELD 
rm=LOCATION_REMOVED 
ha=LOCATION_HAND 
fz=LOCATION_FZONE 
loc_ncp=of+rm --need check public
loc_nncp=dk+ha+ga --not need check public

--Check function
--pos can be e_target
function bm.c.pos(c,e)
	e=e or false	--need to check can be effect's target
	if e and not c:IsCanBeEffectTarget(e) then return false end
	return (c:IsFaceup() and c:IsLocation(loc_ncp)) or (c:IsLocation(loc_nncp) and not c:IsHasEffect(EFFECT_NECRO_VALLEY))
end
--pos is setname
function bm.c.cpos(c,code,e)
	e=e or false
	return bm.c.pos(c,e) and c:IsSetCard(code)
end
--pos is code
function bm.c.npos(c,code,e)
	e=e or false
	return bm.c.pos(c,e) and c:IsCode(code)
end
--can SpecialSummon
function bm.c.sp(c,e,tp,code,sg,sumtype,pos,num)
	sg=sg or nil
	sumtype=sumtype or 0
	pos=pos or POS_FACEUP 
	num=num or 1 
	local flag=bm.c.pos(c) and Duel.GetMZoneCount(tp,sg)>=num 
				and c:IsCanBeSpecialSummoned(e,sumtype,tp,false,false,pos)
	if not code then return flag end
	return flag and c:IsSetCard(code)
end
--GetMatchingGroup
function bm.c.get(e,tp,filter_fun,loc1,loc2,oc,...)
	--local clone_list={...}
	return Duel.GetMatchingGroup(filter_fun,tp,loc1,loc2,oc,...)--clone_list)
end
--IsExisting
function bm.c.has(e,tp,filter_fun,loc1,loc2,num,oc,...)
	--local clone_list={...}
	return bm.c.get(e,tp,filter_fun,loc1,loc2,oc,...):GetCount()>=num--clone_list):GetCount()>=num
end
--can go to where (不能检测表侧移动到魔陷区)
function bm.c.go(c,loc,e,tp,reason,...)
	if not bm.c.pos(c) then return false end
	local f=false
	if loc==mz and not c:IsForbidden() then 
		f=bm.c.sp(c,e,...)
	elseif loc==pz and not c:IsForbidden() then 
		f=Duel.CheckLocation(tp,pz,0) or Duel.CheckLocation(tp,pz,1)
	elseif loc==ex then
		f=c:IsAbleToExtra()
		if reason==bm.re.c then f=c:IsAbleToExtraAsCost() end
	elseif loc==dk then
		f=c:IsAbleToDeck()
		if reason==bm.re.c then f=c:IsAbleToDeckAsCost() end
	elseif loc==dk+ex and reason==bm.re.c then
		f=c:IsAbleToDeckOrExtraAsCost()
	elseif loc==ga then 
		f=c:IsAbleToGrave()
		if reason==bm.re.c then f=c:IsAbleToGraveAsCost() end
	elseif loc==sz then
		f=c:IsSSetable() and Duel.GetLocationCount(tp,sz)>0
	elseif loc==rm then
		f=c:IsAbleToRemove()
		if reason==bm.re.c then f=c:IsAbleToRemoveAsCost() end
	elseif loc==ha then
		f=c:IsAbleToHand()
		if reason==bm.re.c then f=c:IsAbleToHandAsCost() end
	end
	return f
end

--Base effect 
--效果要素
function bm.b.es(e,con,cost,tg,op)  
	local code=e:GetOwner():GetCode()
	if con then
		if type(con)~="function" then
			Debug.Message(code .. " RegisterSolve con must be function")
		end
		e:SetCondition(con)
	end
	if cost then
		if type(cost)~="function" then
			Debug.Message(code .. " RegisterSolve cost must be function")
		end
		e:SetCost(cost)
	end
	if tg then
		if type(tg)~="function" then
			Debug.Message(code .. " RegisterSolve tg must be function")
		end
		e:SetTarget(tg)
	end
	if op then
		if type(op)~="function" then
			Debug.Message(code .. " RegisterSolve op must be function")
		end
		e:SetOperation(op)
	end
end
--Creat effect (影响区域,提示时点,重置方案)
--ce	卡片，描述，效果类型，影响范围类型
--sl	触发方法，使用次数，生效区域
--ef	条件，代价，场合，处理，值
function bm.b.ce(c,ce_desc,ce_cate,ce_type,sl_code,sl_lim,sl_range,ef_con,ef_cost,ef_tg,ef_op,ef_val)	
	local e=Effect.CreateEffect(c)
	if ce_desc then
		e:SetDescription(ce_desc)
	end
	if ce_cate then
		e:SetCategory(ce_cate)
	end
	if ce_type then
		e:SetType(ce_type)
	end
	if sl_code then
		e:SetCode(sl_code)
	end
	if sl_lim then
		if type(sl_lim)=="table" then
			e:SetCountLimit(sl_lim[1],sl_lim[2])
		else
			e:SetCountLimit(sl_lim)
		end
	end
	if sl_range then
		e:SetRange(sl_range)
	end
	bm.b.es(e,ef_con,ef_cost,ef_tg,ef_op)
	if ef_val then
		e:SetValue(ef_val)
	end
	return e
end
--Create base effects
function bm.b.con(e,tp,eg,ep,ev,re,r,rp)
	return true
end
function bm.b.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function bm.b.tar(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
end
function bm.b.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
end
function bm.b.val(e,c)
	return 0
end

--Others fun
--二进制转int (buf to int) buf>0
--l为低位，h为高位，该区间外的部分直接删除
function bm.e.bti(b,l,h)
	if not b then return end
	if h then b=b%(10^h) end
	if l then b=b/(10^l) end
	local i=0
	local ind=0
	while b>0 do
		i=i+(b%(10^ind))*(2^ind)
		b=b-b%(10^ind)
		ind=ind+1
	end
	return i
end
--检测是2的多少次
function bm.e.bev(b)
	if not b then return end
	local i=0
	while b>=2 do
		b=b/2
		i=i+1
	end
	return i
end
--MoveToField函数用位置计算(1~5 to 0xff)
function bm.e.mtfz(b)
	if not b then return end
	if b<2 then
		return b
	else
		local i=0
		for var=0,b-1,1 do
			i=i+bm.e.mtfz(var)
		end
		i=i+1
		return i
	end
end
--[[
	local seq=0
	for tc in aux.Next(tg) do
		seq=seq+tc:GetColumnZone(sz)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local tseq=Duel.SelectField(tp,1,sz,0,~seq)
	tseq=bm.e.bev(tseq)-7
	tseq=bm.e.mtfz(tseq)
--]]
















