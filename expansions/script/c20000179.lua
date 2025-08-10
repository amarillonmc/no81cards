--忍防之圣沌 八方
dofile("expansions/script/c20000175.lua")
local cm, m = fu_HC.Initial()
--e1
cm.e1 = fuef.A():Pro("TG"):Func("tg1,op1")
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g = fugf.GetFilter(tp,"MS","TgChk+Not+IsSet/IsPos","%1,%1,5fd1,FD",nil,e)
	if chkc then return g:IsContains(chkc) end
	if chk==0 then return #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	fugf.SelectTg(tp, g)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc = fusf.GetTarget(e, nil, true)
	fuef.S(e,EFFECT_IMMUNE_EFFECT,tc):Des(0):Pro("HINT+SET"):Val("op1val1"):Res("STD+ED"):Pl(tp)
end
function cm.op1val1(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
--e2
cm.e2 = fuef.FTO("ATK"):Ran("G"):Ctl(m):Func("cos2,tg2,op2")
function cm.cos2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g = fugf.GetFilter(tp,"S","IsCode+IsSeq","175,-4")
	if chk==0 then return #g > 0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local mc = fugf.Select(tp, g):GetFirst()
	if mc:IsFacedown() then Duel.ConfirmCards(1-tp, mc) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local seq = math.log(Duel.SelectDisableField(tp,1,LOCATION_SZONE,0,0),2)-8
	Duel.MoveSequence(mc, seq)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SSet(tp, c)
end